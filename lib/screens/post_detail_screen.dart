import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_provider.dart';
import '../models/post.dart';
import 'post_form_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _commentAuthorController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _commentAuthorController.dispose();
    super.dispose();
  }

  void _addComment() {
    final author = _commentAuthorController.text.trim();
    final content = _commentController.text.trim();
    if (author.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('작성자와 댓글 내용을 모두 입력해주세요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<BoardProvider>().addComment(
          postId: widget.postId,
          content: content,
          author: author,
        );
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _confirmDeletePost(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('게시글 삭제'),
        content: const Text('정말 이 게시글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              context.read<BoardProvider>().deletePost(post.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('게시글이 삭제되었습니다.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteComment(String commentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('정말 이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              context.read<BoardProvider>().deleteComment(
                    postId: widget.postId,
                    commentId: commentId,
                  );
              Navigator.pop(ctx);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<BoardProvider>(
      builder: (context, provider, _) {
        final post = provider.getPost(widget.postId);
        if (post == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('게시글을 찾을 수 없습니다.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('게시글'),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostFormScreen(post: post),
                      ),
                    );
                  } else if (value == 'delete') {
                    _confirmDeletePost(context, post);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('수정')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('삭제', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              post.author.isNotEmpty ? post.author[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.author, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                              Text(post.formattedDate, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                            ],
                          ),
                          const Spacer(),
                          Icon(Icons.visibility_outlined, size: 16, color: theme.colorScheme.outline),
                          const SizedBox(width: 4),
                          Text('${post.viewCount}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        post.content,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                      ),
                      const Divider(height: 40),
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            '댓글 ${post.comments.length}',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (post.comments.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          alignment: Alignment.center,
                          child: Text(
                            '아직 댓글이 없습니다. 첫 댓글을 남겨보세요!',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                          ),
                        )
                      else
                        ...post.comments.map((comment) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: theme.colorScheme.secondaryContainer,
                                        child: Text(
                                          comment.author.isNotEmpty ? comment.author[0].toUpperCase() : '?',
                                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSecondaryContainer),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(comment.author, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Text(comment.formattedDate, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                                      const SizedBox(width: 4),
                                      InkWell(
                                        onTap: () => _confirmDeleteComment(comment.id),
                                        child: Icon(Icons.close, size: 16, color: theme.colorScheme.outline),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(comment.content, style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            )),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _commentAuthorController,
                          decoration: const InputDecoration(
                            hintText: '이름',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: '댓글을 입력하세요...',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14),
                          onSubmitted: (_) => _addComment(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _addComment,
                        icon: const Icon(Icons.send, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
