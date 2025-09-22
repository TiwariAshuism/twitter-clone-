import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/entities/user_entity.dart';
import 'package:chirper/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<String> call({
    required String email,
    required String username,
    required String password,
  }) async {
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      throw AppException("All fields are required");
    }
    if (password.length < 6) {
      throw AppException("Password must be at least 6 characters");
    }

    final user = UserEntity.forRegister(
      email: email,
      username: username,
      password: password,
    );

    return await authRepository.register(user);
  }
}
