part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  const RegisterState({required this.status, this.error});

  final RegisterStatus status;
  final String? error;

  @override
  List<Object?> get props => [status, error];

  RegisterState copyWith({RegisterStatus? status, String? error}) {
    return RegisterState(status: status ?? this.status, error: error);
  }
}
