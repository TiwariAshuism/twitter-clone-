import 'package:chirper/features/feed/data/datasources/feed_local_data_source.dart';
import 'package:chirper/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;
  final FeedLocalDataSource localDataSource;

  FeedRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<PostEntity>> fetchFeed() async {
    try {
      // Try to fetch from remote
      final posts = await remoteDataSource.fetchFeed();

      // Cache the posts locally
      await localDataSource.cacheFeed(posts);

      return posts;
    } catch (e) {
      // If remote fails, try to get cached data
      final cachedPosts = await localDataSource.getCachedFeed();
      if (cachedPosts.isNotEmpty) {
        return cachedPosts;
      }

      // If no cached data, rethrow the error
      rethrow;
    }
  }

  @override
  Future<void> createPost(PostEntity postEntity) async {
    return remoteDataSource.createPost(postEntity);
  }
}
