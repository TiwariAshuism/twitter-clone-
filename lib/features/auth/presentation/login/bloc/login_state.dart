part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({required this.status, this.error});

  final LoginStatus status;
  final String? error;

  @override
  List<Object?> get props => [status, error];

  LoginState copyWith({LoginStatus? status, String? error}) {
    return LoginState(status: status ?? this.status, error: error);
  }
}
