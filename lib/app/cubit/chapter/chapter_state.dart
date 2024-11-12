part of 'chapter_cubit.dart';

abstract class ChapterState extends Equatable {
  const ChapterState();

  @override
  List<Object> get props => [];
}

class ChapterInitial extends ChapterState {}

class ChapterLoading extends ChapterState {}

class ChapterLoaded extends ChapterState {
  final ChapterEntity chapter;

  const ChapterLoaded(this.chapter);

  @override
  List<Object> get props => [chapter];
}

class ChapterError extends ChapterState {
  final String message;

  const ChapterError(this.message);

  @override
  List<Object> get props => [message];
}
