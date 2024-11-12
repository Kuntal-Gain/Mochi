import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/manga_entity.dart';
import '../../../domain/usecases/manga_data/get_chapters_usecase.dart';
import '../../../domain/usecases/manga_data/get_manga_data_usecase.dart';

part 'manga_state.dart';

class MangaCubit extends Cubit<MangaState> {
  final GetMangaDataUsecase getMangaDataUsecase;
  final GetChaptersUsecase getChaptersUsecase;
  MangaCubit({
    required this.getMangaDataUsecase,
    required this.getChaptersUsecase,
  }) : super(MangaInitial());

  Future<void> getMangaData(String id) async {
    emit(MangaLoading());
    try {
      final manga = await getMangaDataUsecase.call(id);
      final chapters = await getChaptersUsecase.call(id);
      emit(MangaLoaded(manga: manga, chapters: chapters));
    } catch (e) {
      emit(MangaError(message: e.toString()));
    }
  }
}
