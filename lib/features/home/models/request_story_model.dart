class RequestStoryModel {
  final String txt;
  final String authorId;
  final String? imageUrl;
  final int color;

  RequestStoryModel({
    required this.txt,
    required this.authorId,
    this.imageUrl,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': txt,
      'author_id': authorId,
      'image_url': imageUrl,
      'color': color,
    };
  }

  factory RequestStoryModel.fromMap(Map<String, dynamic> map) {
    return RequestStoryModel(
      txt: map['text'] as String,
      authorId: map['author_id'] as String,
      imageUrl: map['image_url'] != null ? map['imageUrl'] as String : null,
      color: map['color'] as int,
    );
  }
}
