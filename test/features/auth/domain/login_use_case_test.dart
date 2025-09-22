import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/repository/mockAuthRepository.dart';

void main() {
  group('LoginUseCase', () {
    test('returns token on success', () async {
      final useCase = LoginUseCase(authRepository: MockAuthrepository());
      final token = await useCase(
        const LoginParams(email: 'a@b.com', password: 'p'),
      );
      expect(token, isA<String>());
    });

    test('propagates repository error', () async {
      final useCase = LoginUseCase(authRepository: MockAuthWithError());
      expect(
        () => useCase(const LoginParams(email: 'a@b.com', password: 'p')),
        throwsA(isA<AppException>()),
      );
    });
  });
}
