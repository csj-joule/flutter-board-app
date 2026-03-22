import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../models/comment.dart';

class BoardProvider extends ChangeNotifier {
  final List<Post> _posts = [];
  int _idCounter = 0;
  int _commentIdCounter = 0;

  List<Post> get posts => List.unmodifiable(_posts.reversed.toList());

  // ── Posts CRUD ──

  void addPost({
    required String title,
    required String content,
    required String author,
  }) {
    _idCounter++;
    _posts.add(Post(
      id: _idCounter.toString(),
      title: title,
      content: content,
      author: author,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void updatePost({
    required String id,
    required String title,
    required String content,
  }) {
    final post = _posts.firstWhere((p) => p.id == id);
    post.title = title;
    post.content = content;
    post.updatedAt = DateTime.now();
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Post? getPost(String id) {
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void incrementViewCount(String id) {
    final post = getPost(id);
    if (post != null) {
      post.viewCount++;
      notifyListeners();
    }
  }

  // ── Comments ──

  void addComment({
    required String postId,
    required String content,
    required String author,
  }) {
    final post = getPost(postId);
    if (post == null) return;
    _commentIdCounter++;
    post.comments.add(Comment(
      id: _commentIdCounter.toString(),
      postId: postId,
      content: content,
      author: author,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void deleteComment({required String postId, required String commentId}) {
    final post = getPost(postId);
    if (post == null) return;
    post.comments.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }

  // ── Search ──

  List<Post> search(String query) {
    if (query.isEmpty) return posts;
    final q = query.toLowerCase();
    return posts
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.content.toLowerCase().contains(q) ||
            p.author.toLowerCase().contains(q))
        .toList();
  }
}
