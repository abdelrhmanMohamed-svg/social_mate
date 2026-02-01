class PostModel {
  final String id;
  final String content;
  final String createdAt;
  final String? imageUrl;
  final String? videoUrl;
  final String? fileUrl;
  final String? authorId;
  final String? authorName;
  final String? authorImageUrl;
  final List<String>? likes;
  final List<String>? saves;

  final List<String>? comments;
  final String? fileName;
  final bool isLiked;
  final bool isSaved;
  final int commentsCount;

  const PostModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.authorId,
    this.imageUrl,
    this.videoUrl,
    this.fileUrl,
    this.fileName,
    this.authorName,
    this.authorImageUrl,
    this.likes,
    this.comments,
    this.isLiked = false,
    this.isSaved = false,
    this.commentsCount = 0,
    this.saves,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'created_at': createdAt,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'author_id': authorId,
      'author_name': authorName,
      'author_image_url': authorImageUrl,
      'likes': likes,
      'comments': comments,
      'file_url': fileUrl,
      'file_name': fileName,
      'saves': saves,

    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: map['created_at'] as String,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      videoUrl: map['video_url'] != null ? map['video_url'] as String : null,
      fileUrl: map['file_url'] != null ? map['file_url'] as String : null,
      fileName: map['file_name'] != null ? map['file_name'] as String : null,
      authorId: map['author_id'] != null ? map['author_id'] as String : null,
      authorName: map['author_name'] != null
          ? map['author_name'] as String
          : null,
      authorImageUrl: map['author_image_url'] != null
          ? map['author_image_url'] as String
          : null,
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      comments: map['comments'] != null
          ? List<String>.from((map['comments'] as List<String>))
          : null,
      saves: map['saves'] != null ? List<String>.from((map['saves'])) : null,
    );
  }

  PostModel copyWith({
    String? id,
    String? content,
    String? createdAt,
    String? imageUrl,
    String? videoUrl,
    String? fileUrl,
    String? authorId,
    String? authorName,
    String? authorImageUrl,
    List<String>? likes,
    List<String>? comments,
    String? fileName,
    bool? isLiked,
    int? commentsCount,
    List<String>? saves,
    bool? isSaved,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      fileName: fileName ?? this.fileName,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
      saves: saves ?? this.saves,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
