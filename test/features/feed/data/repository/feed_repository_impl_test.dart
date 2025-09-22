import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_feed_data_source.dart';

void main() {
  group('FeedRepositoryImpl', () {
    late FeedRepositoryImpl repository;
    late MockFeedRemoteDataSource mockRemoteDataSource;
    late MockFeedLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockFeedRemoteDataSource();
      mockLocalDataSource = MockFeedLocalDataSource();
      repository = FeedRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    test('returns posts from remote and caches them', () async {
      final posts = await repository.fetchFeed();

      expect(posts, isA<List<PostEntity>>());
      expect(posts.length, equals(2));

      // Verify posts were cached
      final cachedPosts = await mockLocalDataSource.getCachedFeed();
      expect(cachedPosts.length, equals(2));
    });

    test('returns cached posts when remote fails', () async {
      // First, cache some posts
      final testPosts = [
        PostEntity(
          id: 1,
          content: 'Cached post',
          userId: 'user1',
          timestamp: DateTime.now(),
          imageUrl: '',
          likes: [],
          comments: [],
        ),
      ];
      await mockLocalDataSource.cacheFeed(testPosts);

      // Create repository with failing remote data source
      final repositoryWithFailingRemote = FeedRepositoryImpl(
        remoteDataSource: MockFeedRemoteDataSourceWithError(),
        localDataSource: mockLocalDataSource,
      );

      final posts = await repositoryWithFailingRemote.fetchFeed();

      expect(posts, isA<List<PostEntity>>());
      expect(posts.length, equals(1));
      expect(posts.first.content, equals('Cached post'));
    });

    test('throws error when both remote and cache fail', () async {
      final repositoryWithFailingSources = FeedRepositoryImpl(
        remoteDataSource: MockFeedRemoteDataSourceWithError(),
        localDataSource: MockFeedLocalDataSourceWithError(),
      );

      expect(
        () => repositoryWithFailingSources.fetchFeed(),
        throwsA(isA<AppException>()),
      );
    });
  });
}
