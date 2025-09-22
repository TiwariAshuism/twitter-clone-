part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState extends Equatable {
  const FeedState({required this.status, this.posts, this.error});

  final FeedStatus status;
  final List<PostEntity>? posts;
  final String? error;

  @override
  List<Object?> get props => [status, posts, error];

  FeedState copyWith({
    FeedStatus? status,
    List<PostEntity>? posts,
    String? error,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      error: error,
    );
  }
}
