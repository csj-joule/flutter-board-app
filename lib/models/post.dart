import 'comment.dart';

class Post {
  final String id;
  String title;
  String content;
  String author;
  DateTime createdAt;
  DateTime? updatedAt;
  List<Comment> comments;
  int viewCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.updatedAt,
    List<Comment>? comments,
    this.viewCount = 0,
  }) : comments = comments ?? [];

  String get formattedDate {
    final date = updatedAt ?? createdAt;
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get summary {
    if (content.length <= 80) return content;
    return '${content.substring(0, 80)}...';
  }
}
