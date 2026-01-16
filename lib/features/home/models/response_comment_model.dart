class ResponseCommentModel {
  final String id;
  final String createdAt;
  final String text;
  final String postId;
  final String authorId;
  final String? authorName;
  final String? authorImage;

  ResponseCommentModel({
    required this.id,
    required this.createdAt,
    required this.text,
    required this.postId,
    required this.authorId,
    this.authorName,
    this.authorImage,
  });

  factory ResponseCommentModel.fromMap(Map<String, dynamic> map) {
    return ResponseCommentModel(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      text: map['text'] as String,
      postId: map['post_id'] as String,
      authorId: map['author_id'] as String,
    );
  }

  ResponseCommentModel copyWith({
    String? id,
    String? createdAt,
    String? text,
    String? postId,
    String? authorId,
    String? authorName,
    String? authorImage,
  }) {
    return ResponseCommentModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
    );
  }
}
