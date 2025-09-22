String formatTimestamp(DateTime timestamp) {
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

List<String> extractTags(String content) {
  final tagRegExp = RegExp(r'\B#\w\w+'); // matches words starting with #
  return tagRegExp.allMatches(content).map((m) => m.group(0)!).toList();
}
