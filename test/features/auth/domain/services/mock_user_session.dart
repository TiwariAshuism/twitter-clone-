import 'package:chirper/features/auth/data/repository/datasource/session_local_data_source.dart';
import 'package:chirper/features/auth/domain/services/user_session_service.dart';

class MockUserSessionService implements UserSessionService {
  @override
  Future<void> cacheUserSession({required String token}) {
    return Future.value();
  }

  @override
  Future<String?> getUserSession() {
    return Future.value("mock_token_12345");
  }

  @override
  Future<bool> hasActiveSession() {
    return Future.value(true);
  }

  @override
  // TODO: implement localDataSource
  SessionLocalDataSource get localDataSource => throw UnimplementedError();

  @override
  Future<void> logout() {
    return Future.value();
  }
}
