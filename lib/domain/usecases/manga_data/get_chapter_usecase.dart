import '../../entities/chapter_entity.dart';
import '../../repos/local_repository.dart';

class GetChapterUsecase {
  final LocalRepository localRepository;

  GetChapterUsecase(this.localRepository);

  Future<ChapterEntity> call(String chapterId, String mangaId) {
    return localRepository.getChapterPages(chapterId, mangaId);
  }
}
