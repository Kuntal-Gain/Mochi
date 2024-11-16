// ignore_for_file: overridden_fields

import 'package:mochi/domain/entities/manga_entity.dart';

class MangaModel extends MangaEntity {
  @override
  final String imageUrl;
  @override
  final String name;
  @override
  final String author;
  @override
  final String status;
  @override
  final String updated;
  @override
  final String view;
  @override
  final List<String> genres;
  @override
  final List chapterList;

  const MangaModel({
    required this.imageUrl,
    required this.name,
    required this.author,
    required this.status,
    required this.updated,
    required this.view,
    required this.genres,
    required this.chapterList,
  }) : super(
          imageUrl: imageUrl,
          name: name,
          author: author,
          status: status,
          updated: updated,
          view: view,
          genres: genres,
          chapterList: chapterList,
        );

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      status: json['status'] ?? '',
      updated: json['updated'] ?? '',
      view: json['view'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      chapterList: (json['chapterList'] as List<dynamic>? ?? [])
          .map((chapter) => (chapter as Map<String, dynamic>)['id'] as String)
          .toList(),
    );
  }
}
