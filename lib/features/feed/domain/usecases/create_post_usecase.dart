import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/repositories/feed_repository.dart';

class CreatePostUsecase {
  final FeedRepository feedRepository;
  CreatePostUsecase({required this.feedRepository});
  Future<void> call(PostEntity postEntity) async {
    return await feedRepository.createPost(postEntity);
  }
}
