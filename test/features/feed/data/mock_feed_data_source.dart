import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/feed/data/datasources/feed_local_data_source.dart';
import 'package:chirper/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/repositories/feed_repository.dart';

class MockFeedRemoteDataSource implements FeedRemoteDataSource {
  @override
  Future<List<PostEntity>> fetchFeed() {
    return Future.value([
      PostEntity(
        id: 1,
        content: 'Test post 1',
        userId: 'user1',
        timestamp: DateTime.now(),
        imageUrl: 'https://example.com/image1.jpg',
        likes: ['user2'],
        comments: ['Great post!'],
      ),
      PostEntity(
        id: 2,
        content: 'Test post 2',
        userId: 'user2',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        imageUrl: '',
        likes: ['user1', 'user3'],
        comments: [],
      ),
    ]);
  }
  
  @override
  Future<void> createPost(PostEntity postEntity) {
    return Future.value();
  }
}

class MockFeedRemoteDataSourceWithError implements FeedRemoteDataSource {
  @override
  Future<List<PostEntity>> fetchFeed() {
    return Future.error(AppException('Mock network error'));
  }
  
  @override
  Future<void> createPost(PostEntity postEntity) {
    // TODO: implement createPost
    throw UnimplementedError();
  }
}

class MockFeedLocalDataSource implements FeedLocalDataSource {
  List<PostEntity>? _cachedPosts;

  @override
  Future<List<PostEntity>> getCachedFeed() {
    return Future.value(_cachedPosts ?? []);
  }

  @override
  Future<void> cacheFeed(List<PostEntity> posts) {
    _cachedPosts = posts;
    return Future.value();
  }
}

class MockFeedLocalDataSourceWithError implements FeedLocalDataSource {
  @override
  Future<List<PostEntity>> getCachedFeed() {
    return Future.error(AppException('Mock cache error'));
  }

  @override
  Future<void> cacheFeed(List<PostEntity> posts) {
    return Future.error(AppException('Mock cache error'));
  }
}

class MockFeedRepository implements FeedRepository {
  @override
  Future<List<PostEntity>> fetchFeed() {
    return Future.value([
      PostEntity(
        id: 1,
        content: 'Test post',
        userId: 'user1',
        timestamp: DateTime(2024, 1, 1),
        imageUrl: '',
        likes: [],
        comments: [],
      ),
    ]);
  }
  
  @override
  Future<void> createPost(PostEntity postEntity) {
    // TODO: implement createPost
    throw UnimplementedError();
  }
}

class MockFeedRepositoryWithError implements FeedRepository {
  @override
  Future<List<PostEntity>> fetchFeed() {
    return Future.error(AppException('Mock repository error'));
  }
  
  @override
  Future<void> createPost(PostEntity postEntity) {
    // TODO: implement createPost
    throw UnimplementedError();
  }
}
