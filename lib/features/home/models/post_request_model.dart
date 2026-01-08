
class PostRequestModel {
  final String content;
  final String authorId;
  final String? imageUrl;
  final String? videoUrl;
  final String authorName;
  final String authorImage;


  const PostRequestModel({
    required this.content,
    required this.authorId,
    required this.imageUrl,
    required this.videoUrl,
    required this.authorName,
    required this.authorImage,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'author_id': authorId,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'author_name': authorName,
      'author_image_url': authorImage,
    };
  }

  factory PostRequestModel.fromMap(Map<String, dynamic> map) {
    return PostRequestModel(
      content: map['content'] as String,
      authorId: map['author_id'] as String,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      videoUrl: map['video_url'] != null ? map['video_url'] as String : null,
      authorName: map['author_name'] as String,
      authorImage: map['author_image_url'] as String,
    );
  }


}
