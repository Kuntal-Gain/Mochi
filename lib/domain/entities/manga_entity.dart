import 'package:equatable/equatable.dart';

class MangaEntity extends Equatable {
  final String imageUrl;
  final String name;
  final String author;
  final String status;
  final String updated;
  final String view;
  final List<String> genres;
  final List chapterList;

  const MangaEntity({
    required this.imageUrl,
    required this.name,
    required this.author,
    required this.status,
    required this.updated,
    required this.view,
    required this.genres,
    required this.chapterList,
  });

  @override
  List<Object?> get props => [
        imageUrl,
        name,
        author,
        status,
        updated,
        view,
        genres,
        chapterList,
      ];
}
