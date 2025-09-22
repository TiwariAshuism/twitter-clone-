import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/auth/domain/services/user_session_service.dart';
import 'package:chirper/features/auth/domain/usecases/register_use_case.dart';
import 'package:chirper/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'register_events.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  final RegisterUseCase _registerUseCase;
  final UserSessionService _userSessionService;
  RegisterBloc(
    AuthRepository authRepository,
    RegisterUseCase? registerUseCase,
    UserSessionService userSessionService,
  ) : _authRepository = authRepository,
      _registerUseCase =
          registerUseCase ?? RegisterUseCase(authRepository: authRepository),
      _userSessionService = userSessionService,
      super(const RegisterState(status: RegisterStatus.initial)) {
    on<RegisterSubmitted>(
      _onRegisterSubmitted,
      transformer: (events, mapper) =>
          events.throttleTime(const Duration(seconds: 1)).asyncExpand(mapper),
    );
    on<RegisterReset>(_onRegisterReset);
  }
  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final token = await _registerUseCase.call(
        email: event.email,
        username: event.username,
        password: event.password,
      );
      await _userSessionService.cacheUserSession(token: token);
      emit(state.copyWith(status: RegisterStatus.success));
    } on AppException catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, error: e.message));
    }
  }

  void _onRegisterReset(RegisterReset event, Emitter<RegisterState> emit) {
    emit(const RegisterState(status: RegisterStatus.initial));
  }
}
