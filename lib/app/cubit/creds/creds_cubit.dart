import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mochi/domain/usecases/user/login_user_usecase.dart';
import 'package:mochi/domain/usecases/user/register_user_usecase.dart';

import '../../../domain/entities/user_entity.dart';

part 'creds_state.dart';

class CredsCubit extends Cubit<CredsState> {
  CredsCubit(
      {required this.registerUserUseCase, required this.loginUserUseCase})
      : super(CredsInitial());
  final RegisterUserUseCase registerUserUseCase;
  final LoginUserUseCase loginUserUseCase;

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(CredsLoading());
    try {
      await loginUserUseCase.call(email, password);
      emit(CredsSuccess());
    } on SocketException {
      emit(const CredsFailure(message: 'No Internet Connection'));
    } catch (err) {
      emit(CredsFailure(message: err.toString()));
    }
  }

  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredsLoading());
    try {
      await registerUserUseCase.call(user);
      emit(CredsSuccess());
    } on SocketException {
      emit(const CredsFailure(message: 'No Internet Connection'));
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        emit(const CredsFailure(message: 'User Already Exist'));
      } else if (err.code == 'weak-password') {
        emit(const CredsFailure(message: 'Password is Weak'));
      }
    }
  }
}
