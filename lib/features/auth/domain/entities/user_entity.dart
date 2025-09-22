import 'package:uuid/uuid.dart';

class UserEntity {
  final String id;
  final String email;
  final String? username;
  final String password;

  UserEntity._({
    required this.email,
    required this.password,
    this.username,
  }) : id = const Uuid().v4();

  factory UserEntity.forRegister({
    required String email,
    required String username,
    required String password,
  }) {
    return UserEntity._(email: email, username: username, password: password);
  }

  factory UserEntity.forLogin({
    required String email,
    required String password,
  }) {
    return UserEntity._(email: email, password: password);
  }
}
