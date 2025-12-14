import 'user_entity.dart';

class AuthStatus {
  final bool isAuthenticated;
  final bool isPending;
  final UserEntity? user;

  AuthStatus({
    required this.isAuthenticated,
    required this.isPending,
    required this.user,
  });
}
