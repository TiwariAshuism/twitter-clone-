import 'package:chirper/features/feed/data/datasources/feed_remote_data_source_impl.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedRemoteDataSourceImpl', () {
    late FeedRemoteDataSourceImpl dataSource;

    setUp(() {
      dataSource = FeedRemoteDataSourceImpl();
    });

    test('returns list of posts', () async {
      final posts = await dataSource.fetchFeed();

      expect(posts, isA<List<PostEntity>>());
      expect(posts.length, equals(3));

      // Verify first post structure
      final firstPost = posts.first;
      expect(firstPost.id, equals(1));
      expect(firstPost.content, isNotEmpty);
      expect(firstPost.userId, isNotEmpty);
      expect(firstPost.timestamp, isA<DateTime>());
      expect(firstPost.imageUrl, isNotEmpty);
      expect(firstPost.likes, isA<List<String>>());
      expect(firstPost.comments, isA<List<String>>());
    });

    test('simulates network delay', () async {
      final stopwatch = Stopwatch()..start();
      await dataSource.fetchFeed();
      stopwatch.stop();

      // Should take at least 2 seconds due to simulated delay
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(2000));
    });
  });
}
