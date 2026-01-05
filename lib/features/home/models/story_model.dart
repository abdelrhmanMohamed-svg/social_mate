// ignore_for_file: public_member_api_docs, sort_constructors_first
class StoryModel {
  final String id;
  final String imageUrl;
  final String createdAt;
  final String authorId;
  final String authorName;

  const StoryModel({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.authorId,
     this.authorName='unknown',
  });

  StoryModel copyWith({
    String? id,
    String? imageUrl,
    String? createdAt,
    String? authorId,
    String? authorName,
  }) {
    return StoryModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image_url': imageUrl,
      'created_at': createdAt,
      'author_id': authorId,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      imageUrl: map['image_url'] as String,
      createdAt: map['created_at'] as String,
      authorId: map['author_id'] as String,
    );
  }
}
