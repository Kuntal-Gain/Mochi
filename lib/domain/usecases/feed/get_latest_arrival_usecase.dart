import '../../entities/feed_entity.dart';
import '../../repos/local_repository.dart';

class GetLatestArrivalUsecase {
  final LocalRepository repository;

  GetLatestArrivalUsecase(this.repository);

  Future<List<FeedEntity>> call() async {
    return await repository.getLatestMangaList();
  }
}
