import 'package:chirper/features/feed/domain/entities/post_entity.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostEntity>> fetchFeed();
  Future<void> createPost(PostEntity postEntity);
}
