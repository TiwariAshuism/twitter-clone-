import 'package:chirper/features/feed/data/datasources/feed_local_data_source.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';

class FeedLocalDataSourceImpl implements FeedLocalDataSource {
  List<PostEntity>? _cachedPosts;

  @override
  Future<List<PostEntity>> getCachedFeed() async {
    return _cachedPosts ?? [];
  }

  @override
  Future<void> cacheFeed(List<PostEntity> posts) async {
    _cachedPosts = posts;
  }
}
