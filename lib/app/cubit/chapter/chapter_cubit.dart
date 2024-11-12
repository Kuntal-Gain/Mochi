import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/chapter_entity.dart';
import '../../../domain/usecases/manga_data/get_chapter_usecase.dart';

part 'chapter_state.dart';

class ChapterCubit extends Cubit<ChapterState> {
  final GetChapterUsecase getChapterUsecase;
  ChapterCubit({required this.getChapterUsecase}) : super(ChapterInitial());

  Future<void> getChapter(
      {required String chapterId, required String mangaId}) async {
    emit(ChapterLoading());
    try {
      final chapter = await getChapterUsecase.call(chapterId, mangaId);
      emit(ChapterLoaded(chapter));
    } catch (e) {
      emit(ChapterError(e.toString()));
    }
  }
}
