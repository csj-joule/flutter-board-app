import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_provider.dart';
import '../models/post.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;
  final String? defaultAuthor;

  const PostFormScreen({super.key, this.post, this.defaultAuthor});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _authorController;

  bool get isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _contentController =
        TextEditingController(text: widget.post?.content ?? '');
    _authorController = TextEditingController(
        text: widget.post?.author ?? widget.defaultAuthor ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BoardProvider>();

    if (isEditing) {
      provider.updatePost(
        id: widget.post!.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );
    } else {
      provider.addPost(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        author: _authorController.text.trim(),
      );
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? '게시글이 수정되었습니다.' : '게시글이 등록되었습니다.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '글 수정' : '새 글 작성'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              isEditing ? '수정' : '등록',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isEditing) ...[
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: '작성자',
                    hintText: '이름을 입력하세요',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '작성자를 입력해주세요.' : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력하세요',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '제목을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                minLines: 8,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '내용을 입력해주세요.' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
