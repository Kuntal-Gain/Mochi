import 'package:equatable/equatable.dart';

class ChapterEntity extends Equatable {
  final String title;
  final String currentChapter;
  final List<String> chapterIds; // Will store only the IDs
  final List<String> imageUrls; // Will store only the image URLs

  const ChapterEntity({
    required this.title,
    required this.currentChapter,
    required this.chapterIds,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [title, currentChapter, chapterIds, imageUrls];
}
