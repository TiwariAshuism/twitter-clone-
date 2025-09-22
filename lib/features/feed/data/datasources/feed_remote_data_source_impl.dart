import 'package:chirper/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  @override
  Future<List<PostEntity>> fetchFeed() async {
    List<PostEntity> post = [
      PostEntity(
        id: 1,
        content: 'Hello World! This is my first post! #motivation',
        userId: 'user1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        imageUrl: 'https://picsum.photos/400/300?random=1',
        likes: ['user2', 'user3'],
        comments: ['Great post!', 'Amazing!', 'Love it!'],
      ),
      PostEntity(
        id: 2,
        content: 'Beautiful sunset today 🌅',
        userId: 'user2',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        imageUrl: 'https://picsum.photos/400/300?random=2',
        likes: ['user1', 'user4'],
        comments: ['Stunning!'],
      ),
      PostEntity(
        id: 3,
        content: 'Working on a new project. Excited to share it soon!',
        userId: 'user3',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        imageUrl: '',
        likes: ['user1', 'user2', 'user4'],
        comments: ['Can\'t wait!', 'Looking forward to it!'],
      ),
    ];
    return post;
  }

  @override
  Future<void> createPost(PostEntity postEntity) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real implementation, this would involve sending the postEntity to a backend service.
    // For now, we'll simulate a successful post creation
    print('Post created successfully:');
    print('  ID: ${postEntity.id}');
    print('  Content: ${postEntity.content}');
    print('  User: ${postEntity.userId}');
    print('  Timestamp: ${postEntity.timestamp}');
    print('  Image URL: ${postEntity.imageUrl}');

    // Simulate potential network errors (uncomment to test error handling)
    // if (postEntity.content.toLowerCase().contains('error')) {
    //   throw Exception('Failed to create post: Network error');
    // }
  }
}
