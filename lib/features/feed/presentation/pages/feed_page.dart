import 'package:chirper/core/navigation/navigation_service.dart';
import 'package:chirper/core/navigation/route_paths.dart';
import 'package:chirper/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:chirper/features/feed/presentation/widgets/drawer.dart';
import 'package:chirper/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<FeedBloc>().add(const FeedRefreshed());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state.status == FeedStatus.loading && state.posts == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FeedStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load feed',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeedBloc>().add(const FeedFetched());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final posts = state.posts ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedBloc>().add(const FeedRefreshed());
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return GestureDetector(
                  onTap: () {
                    NavigationService.pushNamed(Routes.detailsPage, args: post);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: Text(post.userId[0].toUpperCase()),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'User',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      post.userId,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      _formatTimestamp(post.timestamp),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(post.content),
                          if (post.imageUrl.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                post.imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                ),
                              ),
                              Text('${post.likes?.length ?? 0}'),
                              const SizedBox(width: 20),

                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 20,
                                ),
                              ),
                              Text('${post.comments?.length ?? 0}'),
                              const SizedBox(width: 20),

                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.repeat, size: 20),
                              ),
                              Text('${post.retweets ?? 0}'),
                              const SizedBox(width: 20),

                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.share, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationService.pushNamed(Routes.createPost);
        },
        child: Icon(AppIcon.fabTweet, size: 16),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
