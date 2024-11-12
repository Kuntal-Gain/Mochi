import 'package:mochi/domain/entities/user_entity.dart';
import 'package:mochi/domain/repos/local_repository.dart';

class RegisterUserUseCase {
  final LocalRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.registerUser(user);
  }
}
