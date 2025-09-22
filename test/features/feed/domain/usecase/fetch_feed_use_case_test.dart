import 'package:chirper/core/error/app_exception.dart';
import 'package:chirper/features/feed/domain/usecases/fetch_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/mock_feed_data_source.dart';

void main() {
  group('FetchFeedUseCase', () {
    test('returns posts on success', () async {
      final useCase = FetchFeedUseCase(feedRepository: MockFeedRepository());
      final posts = await useCase();
      expect(posts, isA<List>());
      expect(posts.length, equals(1));
    });

    test('propagates repository error', () async {
      final useCase = FetchFeedUseCase(
        feedRepository: MockFeedRepositoryWithError(),
      );
      expect(() => useCase(), throwsA(isA<AppException>()));
    });
  });
}
