// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';

class StoryModel {
  final String id;
  final String? imageUrl;
  final String createdAt;
  final String authorId;
  final String authorName;
  final String? text;
  final int color;
  final bool isMine;


  const StoryModel({
    required this.id,
    this.text,
    this.imageUrl,
    required this.createdAt,
    required this.authorId,
    this.authorName = 'unknown',
    required this.color,
    this.isMine = false,
  });

  StoryModel copyWith({
    String? id,
    String? imageUrl,
    String? createdAt,
    String? authorId,
    String? authorName,
    String? text,
    int? color,
    bool? isMine,
  }) {
    return StoryModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      text: text ?? this.text,
      color: color ?? this.color,
      isMine: isMine ?? this.isMine,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image_url': imageUrl,
      'created_at': createdAt,
      'author_id': authorId,
      'text': text,
      'color': color,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      createdAt: map['created_at'] as String,
      authorId: map['author_id'] as String,
      text: map['text'] != null ? map['text'] as String : null,
      color: map['color'] as int,
    );
  }
}

List<Color> storyColors = [
  AppColors.blueStory,
  AppColors.redStory,
  AppColors.yellowStory,
  AppColors.greenStory,
  AppColors.purpleStory,
];
