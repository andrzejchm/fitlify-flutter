import 'package:dartz/dartz.dart';
import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:fitlify_flutter/domain/failures/auth_failure.dart';

abstract class AuthService {
  Future<bool> isLoggedIn();

  Future<Either<AuthFailure, User>> getCurrentUser();

  Future<Either<AuthFailure, User>> logInAnonymously();

  Future<Either<AuthFailure, User>> logInWithApple();

  Future<Either<AuthFailure, Unit>> logOut();
}
