class RequestCommentModel {
  final String text;
  final String postId;
  final String authorId;
  RequestCommentModel({
    required this.text,
    required this.postId,
    required this.authorId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'post_id': postId,
      'author_id': authorId,
    };
  }

  factory RequestCommentModel.fromMap(Map<String, dynamic> map) {
    return RequestCommentModel(
      text: map['text'] as String,
      postId: map['post_id'] as String,
      authorId: map['author_id'] as String,
    );
  }
}
