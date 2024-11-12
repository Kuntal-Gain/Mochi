import '../../domain/entities/chapter_entity.dart';

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required String title,
    required String currentChapter,
    required List<String> chapterIds,
    required List<String> imageUrls,
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
