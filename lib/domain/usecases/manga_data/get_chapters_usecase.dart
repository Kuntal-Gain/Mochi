import '../../repos/local_repository.dart';

class GetChaptersUsecase {
  final LocalRepository localRepository;

  GetChaptersUsecase(this.localRepository);

  Future<List<String>> call(String id) async {
    return localRepository.getChapters(id);
  }
}
