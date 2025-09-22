import 'package:chirper/features/auth/data/repository/datasource/session_local_data_source.dart';

class UserSessionService {
  final SessionLocalDataSource localDataSource;

  UserSessionService({required this.localDataSource});

  Future<void> cacheUserSession({required String token}) async {
    await localDataSource.cacheSession(token: token);
  }

  Future<String?> getUserSession() async {
    return await localDataSource.getCachedSession();
  }

  Future<void> logout() async {
    await localDataSource.clearSession();
  }

  Future<bool> hasActiveSession() async {
    final session = await localDataSource.getCachedSession();
    return session != null;
  }
}
