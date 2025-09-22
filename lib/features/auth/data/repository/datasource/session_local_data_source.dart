import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SessionLocalDataSource {
  Future<void> cacheSession({required String token});
  Future<String?> getCachedSession();
  Future<void> clearSession();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  final FlutterSecureStorage secureStorage;
  SessionLocalDataSourceImpl({required this.secureStorage});
  static const String _session = "_session";
  @override
  Future<void> cacheSession({required String token}) async {
    return await secureStorage.write(key: _session, value: token);
  }

  @override
  Future<void> clearSession() {
    return secureStorage.delete(key: _session);
  }

  @override
  Future<String?> getCachedSession() async {
    return await secureStorage.read(key: _session);
  }
}
