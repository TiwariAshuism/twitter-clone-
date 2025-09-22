import 'package:chirper/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<String> register(UserEntity user);
  Future<String> login(UserEntity user);
}
