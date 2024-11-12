import '../../entities/manga_entity.dart';
import '../../repos/local_repository.dart';

class GetMangaDataUsecase {
  final LocalRepository localRepository;

  GetMangaDataUsecase(this.localRepository);

  Future<MangaEntity> call(String id) async {
    return localRepository.getMangaData(id);
  }
}
