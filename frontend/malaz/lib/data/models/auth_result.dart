import '../../domain/entities/user_entity.dart';

class AuthResult {
  final UserEntity user;
  final bool isPending;

  AuthResult({required this.user, required this.isPending});
}
