import 'package:mochi/domain/repos/local_repository.dart';

class IsSignInUsecase {
  final LocalRepository repository;

  IsSignInUsecase(this.repository);

  Future<bool> call() {
    return repository.isSignIn();
  }
}
