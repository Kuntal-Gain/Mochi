// ignore_for_file: annotate_overrides, overridden_fields, duplicate_ignore

import '../../domain/entities/chapter_entity.dart';

class ChapterModel extends ChapterEntity {
  // ignore: overridden_fields
  final String title;
  final String currentChapter;
  final List<String> chapterIds;
  final List<String> imageUrls;

  const ChapterModel({
    required this.title,
    required this.currentChapter,
    required this.chapterIds,
    required this.imageUrls,
  }) : super(
          title: title,
          currentChapter: currentChapter,
          chapterIds: chapterIds,
          imageUrls: imageUrls,
        );

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> chapterList = json['chapterListIds'] ?? [];
    final List<dynamic> imageList = json['images'] ?? [];

    return ChapterModel(
      title: json['title'] ?? '',
      currentChapter: json['currentChapter'] ?? '',
      chapterIds: chapterList
          .map((chapter) => (chapter as Map<String, dynamic>)['id'] as String)
          .toList(),
      imageUrls: imageList
          .map((image) => (image as Map<String, dynamic>)['image'] as String)
          .toList(),
    );
  }
}
