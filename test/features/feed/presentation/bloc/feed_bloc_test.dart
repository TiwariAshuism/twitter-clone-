import 'package:bloc_test/bloc_test.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:chirper/features/feed/domain/usecases/fetch_post_usecase.dart';
import 'package:chirper/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/mock_feed_data_source.dart';

void main() {
  late MockFeedRepository mockFeedRepository;
  late FeedBloc feedBloc;

  setUp(() {
    mockFeedRepository = MockFeedRepository();
    feedBloc = FeedBloc(
      fetchFeedUseCase: FetchFeedUseCase(feedRepository: mockFeedRepository),
      createPostUsecase: CreatePostUsecase(feedRepository: mockFeedRepository),
    );
  });

  tearDown(() {
    feedBloc.close();
  });

  group("FeedBloc Tests", () {
    blocTest<FeedBloc, FeedState>(
      "emits [loading, success] on valid FeedFetched",
      build: () => feedBloc,
      act: (bloc) => bloc.add(const FeedFetched()),
      expect: () => [
        const FeedState(status: FeedStatus.loading),
        FeedState(
          status: FeedStatus.success,
          posts: [
            PostEntity(
              id: 1,
              content: 'Test post',
              userId: 'user1',
              timestamp: DateTime(2024, 1, 1),
              imageUrl: '',
              likes: [],
              comments: [],
            ),
          ],
        ),
      ],
    );

    blocTest<FeedBloc, FeedState>(
      "emits [loading, success] on valid FeedRefreshed",
      build: () => feedBloc,
      act: (bloc) => bloc.add(const FeedRefreshed()),
      expect: () => [
        const FeedState(status: FeedStatus.loading),
        FeedState(
          status: FeedStatus.success,
          posts: [
            PostEntity(
              id: 1,
              content: 'Test post',
              userId: 'user1',
              timestamp: DateTime(2024, 1, 1),
              imageUrl: '',
              likes: [],
              comments: [],
            ),
          ],
        ),
      ],
    );
  });

  group("FeedBloc Error Handling Tests", () {
    late FeedBloc errorFeedBloc;

    setUp(() {
      errorFeedBloc = FeedBloc(
        fetchFeedUseCase: FetchFeedUseCase(
          feedRepository: MockFeedRepositoryWithError(),
        ),
        createPostUsecase: CreatePostUsecase(
          feedRepository: MockFeedRepositoryWithError(),
        ),
      );
    });

    tearDown(() {
      errorFeedBloc.close();
    });

    blocTest<FeedBloc, FeedState>(
      "emits [loading, failure] when repository throws on FeedFetched",
      build: () => errorFeedBloc,
      act: (bloc) => bloc.add(const FeedFetched()),
      expect: () => const [
        FeedState(status: FeedStatus.loading),
        FeedState(
          status: FeedStatus.failure,
          error: "Exception: Mock repository error",
        ),
      ],
    );

    blocTest<FeedBloc, FeedState>(
      "emits [loading, failure] when repository throws on FeedRefreshed",
      build: () => errorFeedBloc,
      act: (bloc) => bloc.add(const FeedRefreshed()),
      expect: () => const [
        FeedState(status: FeedStatus.loading),
        FeedState(
          status: FeedStatus.failure,
          error: "Exception: Mock repository error",
        ),
      ],
    );
  });
}
