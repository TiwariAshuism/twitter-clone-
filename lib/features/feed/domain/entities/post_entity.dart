import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class PostEntity extends Equatable {
  final int id;
  final String content;
  final String userId;
  final DateTime timestamp;
  final List<String>? likes;
  final List<String>? comments;
  final List<String>? retweets;
  final String imageUrl;
  final String platform; // platform as string

  PostEntity({
    required this.userId,
    required this.timestamp,
    this.likes,
    this.comments,
    required this.imageUrl,
    required this.id,
    required this.content,
    this.retweets,
  }) : platform = _detectPlatform();

  static String _detectPlatform() {
    if (kIsWeb) return "Web";
    if (Platform.isAndroid) return "Android";
    if (Platform.isIOS) return "iOS";
    return "Other";
  }

  @override
  List<Object?> get props => [
    id,
    content,
    userId,
    timestamp,
    likes,
    comments,
    imageUrl,
    retweets,
    platform,
  ];
}
