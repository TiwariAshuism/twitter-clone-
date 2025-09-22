import 'package:chirper/features/auth/domain/entities/user_entity.dart';
import 'package:chirper/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> register(UserEntity user) async {

    return "token_${user.username}";
  }

  @override
  Future<String> login(UserEntity user) async {

    return "token_${user.username}";
  }
}
