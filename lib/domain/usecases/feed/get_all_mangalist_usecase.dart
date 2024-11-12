import '../../entities/feed_entity.dart';
import '../../repos/local_repository.dart';

class GetAllMangaListUsecase {
  final LocalRepository repository;

  GetAllMangaListUsecase(this.repository);

  Future<List<FeedEntity>> call() async {
    return await repository.getAllMangaList();
  }
}
