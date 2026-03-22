class Comment {
  final String id;
  final String postId;
  String content;
  String author;
  DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  String get formattedDate {
    final d = createdAt;
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
