import 'package:chirper/features/feed/domain/entities/post_entity.dart';

abstract class FeedRepository {
  Future<List<PostEntity>> fetchFeed();
  Future<void> createPost(PostEntity postEntity);
}
