import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mochi/domain/usecases/user/get_user_usecase.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUsecase getUserUsecase;

  UserCubit({required this.getUserUsecase}) : super(UserInitial());

  /// Fetch user data
  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      // Execute the use case to fetch user data
      final user = await getUserUsecase.call();
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
