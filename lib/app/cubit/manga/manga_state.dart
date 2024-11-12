part of 'manga_cubit.dart';

abstract class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object> get props => [];
}

class MangaInitial extends MangaState {}

class MangaLoading extends MangaState {}

class MangaLoaded extends MangaState {
  final MangaEntity manga;
  final List<String> chapters;

  const MangaLoaded({
    required this.manga,
    required this.chapters,
  });

  @override
  List<Object> get props => [manga, chapters];
}

class MangaError extends MangaState {
  final String message;

  const MangaError({required this.message});

  @override
  List<Object> get props => [message];
}
