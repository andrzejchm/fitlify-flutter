import 'package:fitlify_flutter/domain/entities/user.dart';
import 'package:fitlify_flutter/domain/stores/current_user_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_doubles/mocks.dart';
import '../../test_doubles/stubs.dart';

void main() {
  group("CurrentUserStore", () {
    CurrentUserStore store;

    void _prepareStore({@required User user}) {
      store = CurrentUserStore();
      store.user = user;
    }

    test("null id is treated as current user if logged in", () {
      _prepareStore(user: Stubs.user);
      expect(store.isCurrentUser(null), true);
    });

    test("isLoggedIn returns false if user is null", () async {
      //
      _prepareStore(user: null);

      expect(store.user, isNull);
    });

    test("isLoggedIn returns true for anonymous user", () async {
      _prepareStore(user: Stubs.anonymousUser);
      expect(store.isLoggedIn, true);
    });

    setUp(() {
      Mocks.setUpDefaultMocks();
    });
  });
}
