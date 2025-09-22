import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/usecases/register_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/repository/mockAuthRepository.dart';

void main() {
  group("RegisterUserUsecase test", () {
    late RegisterUseCase registerUseCase;
    setUp(() {
      registerUseCase = RegisterUseCase(authRepository: MockAuthrepository());
    });

    test('should register user successfully and return token', () async {
      final String email = "test@123.com";
      final String username = 'test';
      final String password = 'test@123';

      final result = await registerUseCase.call(
        email: email,
        username: username,
        password: password,
      );
      expect(result, isA<String>());
    });

    group('handle exceptions for empty fields', () {
      late RegisterUseCase registerUseCase;

      setUp(() {
        registerUseCase = RegisterUseCase(authRepository: MockAuthWithError());
      });

      test('should throw exception when email is empty', () async {
        expect(
          () => registerUseCase.call(
            email: '',
            username: 'test',
            password: 'test@123',
          ),
          throwsA(isA<AppException>()),
        );
      });

      test('should throw exception when username is empty', () async {
        expect(
          () => registerUseCase.call(
            email: 'test@123.com',
            username: '',
            password: 'test@123',
          ),
          throwsA(isA<AppException>()),
        );
      });

      test('should throw exception when password is empty', () async {
        expect(
          () => registerUseCase.call(
            email: 'test@123.com',
            username: 'test',
            password: '',
          ),
          throwsA(isA<AppException>()),
        );
      });
    });
  });
}
