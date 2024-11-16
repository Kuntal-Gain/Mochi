import '../../entities/user_entity.dart';
import '../../repos/local_repository.dart';

class GetUserUsecase {
  final LocalRepository localRepository;

  GetUserUsecase(this.localRepository);

  Future<UserEntity> call() async {
    return await localRepository.getUser();
  }
}
