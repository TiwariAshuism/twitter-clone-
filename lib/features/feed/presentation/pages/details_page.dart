import 'package:chirper/core/presentation/widgets/texttile.dart';
import 'package:chirper/core/utils/utils.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final PostEntity post;
  const DetailsPage({super.key, required this.post});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thread"), centerTitle: true),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(widget.post.userId[0].toUpperCase())),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.post.userId,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                      ),
                      SizedBox(width: 2),
                    ],
                  ),
                ),
                Icon(Icons.arrow_downward),
              ],
            ),

            const SizedBox(height: 12),
            SizedBox(height: 26),
            TitleText(widget.post.content, fontWeight: FontWeight.w500),
            SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: extractTags(widget.post.content).map((tag) {
                return TitleText(tag, color: Theme.of(context).primaryColor);
              }).toList(),
            ),
            if (widget.post.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.post.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 30),
            Row(
              children: [
                Text(formatTimestamp(widget.post.timestamp)),
                SizedBox(width: 12),
                TitleText(
                  "Tweeted from ${widget.post.platform.toString()}",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Column(
              children: [
                const Divider(thickness: 0.4),
                if ((widget.post.comments?.isNotEmpty ?? false) ||
                    (widget.post.likes?.isNotEmpty ?? false))
                  Row(
                    children: [
                      if (widget.post.comments?.isNotEmpty ?? false) ...[
                        TitleText(widget.post.comments!.length.toString()),
                        const SizedBox(width: 5),
                        const Text("Comments"),
                        const SizedBox(width: 10),
                      ],
                      if (widget.post.likes?.isNotEmpty ?? false) ...[
                        TitleText(widget.post.likes!.length.toString()),
                        const SizedBox(width: 5),
                        const Text("Liked"),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),
                const Divider(thickness: 0.4),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, size: 20),
                ),
                Text('${widget.post.likes?.length ?? 0}'),
                const SizedBox(width: 20),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined, size: 20),
                ),
                Text('${widget.post.comments?.length ?? 0}'),
                const SizedBox(width: 20),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.repeat, size: 20),
                ),
                Text('${widget.post.retweets ?? 0}'),
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
    );
  }
}
