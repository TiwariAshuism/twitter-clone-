part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedFetched extends FeedEvent {
  const FeedFetched();
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}

class CreatePost extends FeedEvent {
  final PostEntity postEntity;

  const CreatePost({required this.postEntity});

  @override
  List<Object?> get props => [postEntity];
}
