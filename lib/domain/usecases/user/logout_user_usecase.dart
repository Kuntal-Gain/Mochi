import 'package:mochi/domain/repos/local_repository.dart';

class LogoutUserUseCase {
  final LocalRepository repository;

  LogoutUserUseCase(this.repository);

  Future<void> call() async {
    return await repository.logoutUser();
  }
}
