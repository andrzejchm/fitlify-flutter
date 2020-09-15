import 'package:fitlify_flutter/domain/entities/user.dart';

class ProfileInitialParams {
  final User user;

  ProfileInitialParams(this.user);

  ProfileInitialParams.currentUser() : user = null;
}
