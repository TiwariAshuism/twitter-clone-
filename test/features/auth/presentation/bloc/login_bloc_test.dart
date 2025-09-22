import 'package:bloc_test/bloc_test.dart';
import 'package:chirper/features/auth/domain/usecases/login_use_case.dart';
import 'package:chirper/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/repository/mockAuthRepository.dart';
import '../../domain/services/mock_user_session.dart';

void main() {
  late MockAuthrepository mockAuthRepository;
  late LoginBloc loginBloc;
  MockUserSessionService mockUserSessionService = MockUserSessionService();

  setUp(() {
    mockAuthRepository = MockAuthrepository();
    loginBloc = LoginBloc(
      LoginUseCase(authRepository: mockAuthRepository),
      mockUserSessionService,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  group("LoginBloc Tests", () {
    blocTest<LoginBloc, LoginState>(
      "emits [loading, success] on valid LoginSubmitted",
      build: () => loginBloc,
      act: (bloc) => bloc.add(
        const LoginSubmitted(email: "test@123.com", password: "test@123"),
      ),
      expect: () => const [
        LoginState(status: LoginStatus.loading),
        LoginState(status: LoginStatus.success),
      ],
    );
  });

  group("LoginBloc Error Handling Tests", () {
    late LoginBloc errorLoginBloc;

    setUp(() {
      errorLoginBloc = LoginBloc(
        LoginUseCase(authRepository: MockAuthWithError()),
        mockUserSessionService,
      );
    });

    tearDown(() {
      errorLoginBloc.close();
    });

    blocTest<LoginBloc, LoginState>(
      "emits [loading, failure] on LoginSubmitted with empty email",
      build: () => errorLoginBloc,
      act: (bloc) =>
          bloc.add(const LoginSubmitted(email: "", password: "test@123")),
      expect: () => const [
        LoginState(status: LoginStatus.loading),
        LoginState(
          status: LoginStatus.failure,
          error: "All fields are required",
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "emits [loading, failure] on LoginSubmitted with empty password",
      build: () => errorLoginBloc,
      act: (bloc) =>
          bloc.add(const LoginSubmitted(email: "test@123.com", password: "")),
      expect: () => const [
        LoginState(status: LoginStatus.loading),
        LoginState(
          status: LoginStatus.failure,
          error: "All fields are required",
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      "emits [loading, failure] when repository throws",
      build: () => errorLoginBloc,
      act: (bloc) => bloc.add(
        const LoginSubmitted(email: "valid@mail.com", password: "validpass"),
      ),
      expect: () => const [
        LoginState(status: LoginStatus.loading),
        LoginState(status: LoginStatus.failure, error: "Mock login error"),
      ],
    );
  });
}
