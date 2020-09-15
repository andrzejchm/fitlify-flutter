import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlify_flutter/core/utils/logger.dart';
import 'package:fitlify_flutter/domain/entities/user.dart' as domain;
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';
import 'package:fitlify_flutter/domain/services/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@Injectable(as: AuthService)
class FirebaseAuthService implements AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  Future<bool> isLoggedIn() async => _auth.currentUser != null;

  @override
  Future<Either<AuthFailure, domain.User>> logInAnonymously() async {
    try {
      final firebaseUser = await _auth.signInAnonymously();
      return right(firebaseUser.user.toDomain());
    } catch (e) {
      return left(AuthFailure.unknown(e, "While logging in anonymously"));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> logOut() async {
    try {
      await _auth.signOut();
      return right(unit);
    } catch (e, stack) {
      logError(e, stack);
      return left(AuthFailure.unknown(e, "while logging out in firebase"));
    }
  }

  @override
  Future<Either<AuthFailure, domain.User>> getCurrentUser() async {
    if (_auth.currentUser != null) {
      debugLog("User exists in firebase auth, returning immediately: ${_auth.currentUser.toDomain()}", this);
      return right(_auth.currentUser.toDomain());
    }
    debugLog("Waiting for user in firebase auth...", this);
    final firebaseUser = await _auth.userChanges().first;
    debugLog("received first update on the firebase user: ${firebaseUser?.toDomain()}", this);
    if (firebaseUser != null) {
      return right(firebaseUser.toDomain());
    }
    return left(const AuthFailure.notLoggedIn());
  }

  @override
  Future<Either<AuthFailure, domain.User>> logInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);
      final cred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final firebaseCred = OAuthProvider("apple.com").credential(
        idToken: cred.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential user;
      if (_auth.currentUser?.isAnonymous ?? false) {
        debugLog(
            "Already in anonymous session, attempting to link anonymous user"
            " with apple credentials",
            this);
        try {
          user = await _auth.currentUser.linkWithCredential(firebaseCred);
        } on FirebaseAuthException catch (e) {
          if (e.code == "credential-already-in-use") {
            debugLog(
                "Seems like credential is already in use with other account. "
                "Discarding current section and logging in with existing account`",
                this);
            user = await _auth.signInWithCredential(e.credential);
          } else {
            rethrow;
          }
        }
      } else {
        debugLog("No user session, attempting to sign in with apple credentials", this);
        user = await _auth.signInWithCredential(firebaseCred);
      }
      if ((cred.givenName != null && cred.givenName.isNotEmpty) || (cred.familyName != null && cred.familyName.isNotEmpty)) {
        await _auth.currentUser.updateProfile(displayName: "${cred.givenName} ${cred.familyName}");
      }
      return right(user.user.toDomain());
    } catch (e, stack) {
      logError(e, stack);
      return left(AuthFailure.unknown(e, "While logging in with apple"));
    }
  }
}

String _generateNonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String _sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

extension DomainUser on User {
  domain.User toDomain({String displayName}) {
    return domain.User(
      id: uid,
      isAnonymous: isAnonymous,
      displayName: displayName ?? this.displayName,
      avatarUrl: photoURL,
    );
  }
}
