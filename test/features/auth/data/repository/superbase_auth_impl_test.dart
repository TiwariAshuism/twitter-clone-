import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/entities/user_entity.dart';
import 'package:chirper/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthImpl extends AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<String> login(UserEntity user) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: user.email,
        password: user.password,
      );

      return _getAccessToken(response, "Login");
    } catch (e) {
      throw AppException("Login error: $e");
    }
  }

  @override
  Future<String> register(UserEntity user) async {
    try {
      final response = await _client.auth.signUp(
        email: user.email,
        password: user.password,
        data: {"username": user.username},
      );

      return _getAccessToken(response, "Signup");
    } catch (e) {
      throw AppException("Signup error: $e");
    }
  }

  String _getAccessToken(AuthResponse response, String action) {
    final session = response.session;

    if (session != null && session.accessToken.isNotEmpty) {
      return session.accessToken;
    } else {
      throw AppException("$action failed: No session or access token.");
    }
  }
}
