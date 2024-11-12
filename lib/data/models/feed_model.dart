// ignore_for_file: overridden_fields, annotate_overrides

import 'package:mochi/domain/entities/feed_entity.dart';

class FeedModel extends FeedEntity {
  final String id;
  final String image;
  final String title;
  final String chapter;
  final String view;
  final String description;

  const FeedModel({
    required this.id,
    required this.image,
    required this.title,
    required this.chapter,
    required this.view,
    required this.description,
  }) : super(
          id: id,
          image: image,
          title: title,
          chapter: chapter,
          view: view,
          description: description,
        );

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      chapter: json['chapter'] ?? '',
      view: json['view'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
