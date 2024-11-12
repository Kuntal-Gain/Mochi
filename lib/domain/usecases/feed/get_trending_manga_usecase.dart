import '../../entities/feed_entity.dart';
import '../../repos/local_repository.dart';

class GetTrendingMangaListUsecase {
  final LocalRepository repository;

  GetTrendingMangaListUsecase(this.repository);

  Future<List<FeedEntity>> call() async {
    return await repository.getTrendingMangaList();
  }
}
