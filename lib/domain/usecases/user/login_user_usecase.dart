import 'package:mochi/domain/repos/local_repository.dart';

class LoginUserUseCase {
  final LocalRepository repository;

  LoginUserUseCase(this.repository);

  Future<void> call(String email, String password) async {
    return await repository.loginUser(email, password);
  }
}
