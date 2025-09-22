part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String username;
  final String password;

  const RegisterSubmitted({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [email, username, password];
}

class RegisterReset extends RegisterEvent {
  const RegisterReset();
}
