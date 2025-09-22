import 'package:bloc_test/bloc_test.dart';
import 'package:chirper/features/auth/domain/usecases/register_use_case.dart';
import 'package:chirper/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/repository/mockAuthRepository.dart';
import '../../domain/services/mock_user_session.dart';

void main() {
  late MockAuthrepository mockAuthRepository;
  late RegisterBloc registerBloc;
  MockUserSessionService mockUserSessionService = MockUserSessionService();
  setUp(() {
    mockAuthRepository = MockAuthrepository();
    registerBloc = RegisterBloc(
      mockAuthRepository,
      RegisterUseCase(authRepository: mockAuthRepository),
      mockUserSessionService,
    );
  });

  tearDown(() {
    registerBloc.close();
  });

  group("RegisterBloc Tests", () {
    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, success] on valid RegisterSubmitted",
      build: () => registerBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(
          email: "test@123.com",
          username: "test",
          password: "test@123",
        ),
      ),
      //wait: const Duration(seconds: 3),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(status: RegisterStatus.success),
      ],
    );
  });

  group("RegisterBloc Error Handling Tests", () {
    late RegisterBloc errorRegisterBloc;

    setUp(() {
      errorRegisterBloc = RegisterBloc(
        MockAuthWithError(),
        RegisterUseCase(authRepository: MockAuthWithError()),
        mockUserSessionService,
      );
    });

    tearDown(() {
      errorRegisterBloc.close();
    });

    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, failure] on RegisterSubmitted with empty email",
      build: () => errorRegisterBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(
          email: "",
          username: "test",
          password: "test@123",
        ),
      ),
      //wait: const Duration(seconds: 3),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(
          status: RegisterStatus.failure,
          error: "All fields are required",
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, failure] on RegisterSubmitted with empty username",
      build: () => errorRegisterBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(email: "", username: "", password: "test@123"),
      ),
      //wait: const Duration(seconds: 3),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(
          status: RegisterStatus.failure,
          error: "All fields are required",
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, failure] when repository throws",
      build: () => errorRegisterBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(
          email: "valid@mail.com",
          username: "valid",
          password: "validpass",
        ),
      ),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(
          status: RegisterStatus.failure,
          error: "Mock registration error",
        ),
      ],
    );
  });
}
import 'package:bloc_test/bloc_test.dart';
import 'package:chirper/features/auth/domain/usecases/register_use_case.dart';
import 'package:chirper/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/repository/mockAuthRepository.dart';
import '../../domain/services/mock_user_session.dart';

void main() {
  late MockAuthrepository mockAuthRepository;
  late RegisterBloc registerBloc;
  MockUserSessionService mockUserSessionService = MockUserSessionService();
  setUp(() {
    mockAuthRepository = MockAuthrepository();
    registerBloc = RegisterBloc(
      mockAuthRepository,
      RegisterUseCase(authRepository: mockAuthRepository),
      mockUserSessionService,
    );
  });

  tearDown(() {
    registerBloc.close();
  });

  group("RegisterBloc Tests", () {
    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, success] on valid RegisterSubmitted",
      build: () => registerBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(
          email: "test@123.com",
          username: "test",
          password: "test@123",
        ),
      ),
      //wait: const Duration(seconds: 3),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(status: RegisterStatus.success),
      ],
    );
  });

  group("RegisterBloc Error Handling Tests", () {
    late RegisterBloc errorRegisterBloc;

    setUp(() {
      errorRegisterBloc = RegisterBloc(
        MockAuthWithError(),
        RegisterUseCase(authRepository: MockAuthWithError()),
        mockUserSessionService,
      );
    });

    tearDown(() {
      errorRegisterBloc.close();
    });

    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, failure] on RegisterSubmitted with empty email",
      build: () => errorRegisterBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(
          email: "",
          username: "test",
          password: "test@123",
        ),
      ),
      //wait: const Duration(seconds: 3),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(
          status: RegisterStatus.failure,
          error: "All fields are required",
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, failure] on RegisterSubmitted with empty username",
      build: () => errorRegisterBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(email: "", username: "", password: "test@123"),
      ),
      //wait: const Duration(seconds: 3),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(
          status: RegisterStatus.failure,
          error: "All fields are required",
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      "emits [loading, failure] when repository throws",
      build: () => errorRegisterBloc,
      act: (bloc) => bloc.add(
        const RegisterSubmitted(
          email: "valid@mail.com",
          username: "valid",
          password: "validpass",
        ),
      ),
      expect: () => const [
        RegisterState(status: RegisterStatus.loading),
        RegisterState(
          status: RegisterStatus.failure,
          error: "Exception: Mock registration error",
        ),
      ],
    );
  });
}
