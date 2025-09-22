import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/entities/user_entity.dart';
import 'package:chirper/features/auth/domain/repository/auth_repository.dart';

class MockAuthrepository implements AuthRepository {
  @override
  Future<String> register(UserEntity user) {
    return Future.value("mock_token_12345");
  }

  @override
  Future<String> login(UserEntity user) {
    return Future.value("mock_token_12345");
  }
}

class MockAuthWithError implements AuthRepository {
  @override
  Future<String> register(UserEntity user) {
    return Future.error(AppException("Mock registration error"));
  }

  @override
  Future<String> login(UserEntity user) {
    return Future.error(AppException("Mock login error"));
  }
}
