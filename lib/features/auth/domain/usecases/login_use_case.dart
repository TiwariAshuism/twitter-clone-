import 'package:chirper/features/auth/domain/entities/user_entity.dart';
import 'package:chirper/features/auth/domain/repository/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<String> call(LoginParams params) async {
    final user = UserEntity.forLogin(
      email: params.email,
      password: params.password,
    );
    return authRepository.login(user);
  }
}
