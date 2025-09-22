import 'package:chirper/core/navigation/navigation_service.dart';
import 'package:chirper/core/navigation/page_trasition.dart';
import 'package:chirper/core/routing/app_router.dart';
import 'package:chirper/features/auth/data/repository/auth_repository_impl.dart';
import 'package:chirper/features/auth/data/repository/datasource/session_local_data_source.dart';
import 'package:chirper/features/auth/domain/services/user_session_service.dart';
import 'package:chirper/features/splash/splash_screen.dart';
import 'package:chirper/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  final authRepository = AuthRepositoryImpl();
  final userSessionService = UserSessionService(
    localDataSource: SessionLocalDataSourceImpl(
      secureStorage: FlutterSecureStorage(),
    ),
  );
  NavigationService.setDefaultAnimation(
    animationType: AnimationType.slideFromRight,
    duration: Duration(milliseconds: 250),
    curve: Curves.easeInOut,
  );
  runApp(
    MyApp(
      authRepository: authRepository,
      userSessionService: userSessionService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final UserSessionService userSessionService;
  const MyApp({
    super.key,
    required this.authRepository,
    required this.userSessionService,
  });

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(authRepository, userSessionService);

    return RepositoryProvider.value(
      value: authRepository,
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        theme: AppTheme.appTheme.copyWith(
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme),
        ),
        title: 'Chirper',
        onGenerateRoute: appRouter.generateRoute,
        home: SplashScreen(userSessionService: userSessionService),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
