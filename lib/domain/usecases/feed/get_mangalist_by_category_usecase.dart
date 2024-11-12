import '../../entities/feed_entity.dart';
import '../../repos/local_repository.dart';

class GetMangaListByCategoryUsecase {
  final LocalRepository repository;

  GetMangaListByCategoryUsecase(this.repository);

  Future<List<FeedEntity>> call(String category) async {
    return await repository.getMangaListByCategory(category);
  }
}
