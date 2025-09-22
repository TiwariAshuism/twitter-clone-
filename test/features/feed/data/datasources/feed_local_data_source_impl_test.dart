import 'package:chirper/features/feed/data/datasources/feed_local_data_source_impl.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedLocalDataSourceImpl', () {
    late FeedLocalDataSourceImpl dataSource;

    setUp(() {
      dataSource = FeedLocalDataSourceImpl();
    });

    test('returns empty list when no cached posts', () async {
      final posts = await dataSource.getCachedFeed();

      expect(posts, isA<List<PostEntity>>());
      expect(posts, isEmpty);
    });

    test('caches and retrieves posts', () async {
      final testPosts = [
        PostEntity(
          id: 1,
          content: 'Test post',
          userId: 'user1',
          timestamp: DateTime.now(),
          imageUrl: '',
          likes: [],
          comments: [],
        ),
        PostEntity(
          id: 2,
          content: 'Another test post',
          userId: 'user2',
          timestamp: DateTime.now(),
          imageUrl: 'https://example.com/image.jpg',
          likes: ['user1'],
          comments: ['Great!'],
        ),
      ];

      // Cache posts
      await dataSource.cacheFeed(testPosts);

      // Retrieve cached posts
      final cachedPosts = await dataSource.getCachedFeed();

      expect(cachedPosts, isA<List<PostEntity>>());
      expect(cachedPosts.length, equals(2));
      expect(cachedPosts.first.content, equals('Test post'));
      expect(cachedPosts.last.content, equals('Another test post'));
    });

    test('overwrites previous cache when caching new posts', () async {
      final firstPosts = [
        PostEntity(
          id: 1,
          content: 'First post',
          userId: 'user1',
          timestamp: DateTime.now(),
          imageUrl: '',
          likes: [],
          comments: [],
        ),
      ];

      final secondPosts = [
        PostEntity(
          id: 2,
          content: 'Second post',
          userId: 'user2',
          timestamp: DateTime.now(),
          imageUrl: '',
          likes: [],
          comments: [],
        ),
      ];

      // Cache first set
      await dataSource.cacheFeed(firstPosts);

      // Cache second set (should overwrite)
      await dataSource.cacheFeed(secondPosts);

      // Retrieve cached posts
      final cachedPosts = await dataSource.getCachedFeed();

      expect(cachedPosts.length, equals(1));
      expect(cachedPosts.first.content, equals('Second post'));
    });
  });
}
