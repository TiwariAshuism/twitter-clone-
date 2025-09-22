import 'package:chirper/features/feed/domain/entities/post_entity.dart';

abstract class FeedLocalDataSource {
  Future<List<PostEntity>> getCachedFeed();
  Future<void> cacheFeed(List<PostEntity> posts);
}
