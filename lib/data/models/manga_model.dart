import 'package:mochi/domain/entities/manga_entity.dart';

class MangaModel extends MangaEntity {
  const MangaModel({
    required String imageUrl,
    required String name,
    required String author,
    required String status,
    required String updated,
    required String view,
    required List<String> genres,
    required List chapterList,
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
