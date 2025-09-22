import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/services/user_session_service.dart';
import 'package:chirper/features/auth/domain/usecases/login_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_events.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final UserSessionService _userSessionService;
  LoginBloc(LoginUseCase loginUseCase, UserSessionService userSessionService)
    : _userSessionService = userSessionService,
      _loginUseCase = loginUseCase,
      super(const LoginState(status: LoginStatus.initial)) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        throw AppException("All fields are required");
      }
      final token = await _loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      await _userSessionService.cacheUserSession(token: token);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e.toString()));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginState(status: LoginStatus.initial));
  }
}
