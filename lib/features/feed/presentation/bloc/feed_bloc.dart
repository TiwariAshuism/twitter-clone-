import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/domain/usecases/fetch_post_usecase.dart';
import 'package:chirper/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_events.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FetchFeedUseCase fetchFeedUseCase;
  final CreatePostUsecase createPostUsecase;

  FeedBloc({required this.fetchFeedUseCase, required this.createPostUsecase})
    : super(const FeedState(status: FeedStatus.initial)) {
    on<FeedFetched>(_onFeedFetched);
    on<FeedRefreshed>(_onFeedRefreshed);
    on<CreatePost>(_onCreatePost);
  }

  Future<void> _onFeedFetched(
    FeedFetched event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));
    try {
      final posts = await fetchFeedUseCase();
      emit(state.copyWith(status: FeedStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(status: FeedStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onFeedRefreshed(
    FeedRefreshed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));
    try {
      final posts = await fetchFeedUseCase();
      emit(state.copyWith(status: FeedStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(status: FeedStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<FeedState> emit) async {
    try {
      await createPostUsecase(event.postEntity);
      // After creating post, refresh the feed to show the new post
      add(const FeedRefreshed());
    } catch (e) {
      emit(state.copyWith(status: FeedStatus.failure, error: e.toString()));
    }
  }
}
