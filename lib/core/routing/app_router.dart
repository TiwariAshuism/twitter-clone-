import 'package:chirper/features/auth/domain/services/user_session_service.dart';
import 'package:chirper/features/feed/data/datasources/feed_local_data_source_impl.dart';
import 'package:chirper/features/feed/data/datasources/feed_remote_data_source_impl.dart';
import 'package:chirper/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:chirper/features/feed/domain/usecases/fetch_post_usecase.dart';
import 'package:chirper/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:chirper/features/feed/presentation/pages/create_post_page.dart';
import 'package:chirper/features/feed/presentation/pages/details_page.dart';
import 'package:chirper/features/home/presentation/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chirper/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:chirper/features/auth/presentation/login/login_page.dart';
import 'package:chirper/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:chirper/features/auth/presentation/register/registration_page.dart';
import 'package:chirper/features/auth/domain/usecases/login_use_case.dart';
import 'package:chirper/features/auth/domain/usecases/register_use_case.dart';
import 'package:chirper/features/auth/data/repository/auth_repository_impl.dart';
import '../navigation/route_paths.dart';

class AppRouter {
  final AuthRepositoryImpl authRepository;
  final UserSessionService userSessionService;
  AppRouter(this.authRepository, this.userSessionService);

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LoginBloc(
              LoginUseCase(authRepository: authRepository),
              userSessionService,
            ),
            child: const LoginPage(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegisterBloc(
              authRepository,
              RegisterUseCase(authRepository: authRepository),
              userSessionService,
            ),
            child: const RegistrationPage(),
          ),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FeedBloc(
              fetchFeedUseCase: FetchFeedUseCase(
                feedRepository: FeedRepositoryImpl(
                  localDataSource: FeedLocalDataSourceImpl(),
                  remoteDataSource: FeedRemoteDataSourceImpl(),
                ),
              ),
              createPostUsecase: CreatePostUsecase(
                feedRepository: FeedRepositoryImpl(
                  localDataSource: FeedLocalDataSourceImpl(),
                  remoteDataSource: FeedRemoteDataSourceImpl(),
                ),
              ),
            )..add(FeedFetched()),
            child: const HomePage(),
          ),
        );
      case Routes.createPost:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FeedBloc(
              fetchFeedUseCase: FetchFeedUseCase(
                feedRepository: FeedRepositoryImpl(
                  localDataSource: FeedLocalDataSourceImpl(),
                  remoteDataSource: FeedRemoteDataSourceImpl(),
                ),
              ),
              createPostUsecase: CreatePostUsecase(
                feedRepository: FeedRepositoryImpl(
                  localDataSource: FeedLocalDataSourceImpl(),
                  remoteDataSource: FeedRemoteDataSourceImpl(),
                ),
              ),
            ),
            child: const CreatePostPage(),
          ),
        );
      case Routes.detailsPage:
        final post = settings.arguments as PostEntity;
        return MaterialPageRoute(builder: (_) => DetailsPage(post: post));
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Unknown route'))),
        );
    }
  }
}
