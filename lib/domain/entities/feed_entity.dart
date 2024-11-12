import 'package:equatable/equatable.dart';

class FeedEntity extends Equatable {
  final String id;
  final String image;
  final String title;
  final String chapter;
  final String view;
  final String description;

  const FeedEntity({
    required this.id,
    required this.image,
    required this.title,
    required this.chapter,
    required this.view,
    required this.description,
  });

  @override
  List<Object?> get props => [id, image, title, chapter, view, description];
}
