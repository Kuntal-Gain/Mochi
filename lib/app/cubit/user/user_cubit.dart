import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mochi/domain/usecases/user/logout_user_usecase.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/login_user_usecase.dart';
import '../../../domain/usecases/user/register_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final LoginUserUseCase loginUserUseCase;
  final RegisterUserUseCase signupUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  UserCubit({
    required this.loginUserUseCase,
    required this.signupUserUseCase,
    required this.logoutUserUseCase,
  }) : super(UserInitial());

  Future<void> login(UserEntity user) async {
    try {
      emit(UserLoading());
      await loginUserUseCase(user.email, user.password);
      emit(UserAuthenticated(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> signup(UserEntity user) async {
    try {
      emit(UserLoading());
      await signupUserUseCase(user);
      emit(UserAuthenticated(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(UserLoading());
      await logoutUserUseCase();
      emit(UserUnauthenticated());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void appStarted() {
    emit(UserUnauthenticated());
  }
}
