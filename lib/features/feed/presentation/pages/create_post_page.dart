import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chirper/features/feed/domain/entities/post_entity.dart';
import 'package:chirper/features/feed/presentation/bloc/feed_bloc.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _createPost() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some content for your post'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final postEntity = PostEntity(
      id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
      content: _contentController.text.trim(),
      userId: 'current_user', // In a real app, get from auth service
      timestamp: DateTime.now(),
      imageUrl: _imageUrlController.text.trim(),
      likes: [],
      comments: [],
    );

    context.read<FeedBloc>().add(CreatePost(postEntity: postEntity));

    // Navigate back after creating post
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createPost,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content input
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            // Image URL input
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 16),
            // Preview image if URL is provided
            if (_imageUrlController.text.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            Text('Invalid image URL'),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
