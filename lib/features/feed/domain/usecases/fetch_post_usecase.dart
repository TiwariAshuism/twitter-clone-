import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/repositories/feed_repository.dart';

class FetchFeedUseCase {
  final FeedRepository feedRepository;

  FetchFeedUseCase({required this.feedRepository});

  Future<List<PostEntity>> call() async {
    return await feedRepository.fetchFeed();
  }
}
