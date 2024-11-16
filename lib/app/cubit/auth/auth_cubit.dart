import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mochi/domain/usecases/user/logout_user_usecase.dart';

import '../../../domain/usecases/user/is_sign_in_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LogoutUserUseCase signOutUsecase;

  final IsSignInUsecase isSignInUsecase;

  AuthCubit({
    required this.signOutUsecase,
    required this.isSignInUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUsecase.call();

      if (isSignIn == true) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        emit(Authenticated(uid: uid!));
      } else {
        emit(const NotAuthenticated());
      }
    } catch (_) {
      emit(const NotAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      emit(Authenticated(uid: uid!));
    } catch (_) {
      emit(const NotAuthenticated());
    }
  }

  Future<void> logout() async {
    try {
      await signOutUsecase.call();
      emit(const NotAuthenticated());
    } catch (_) {
      emit(const NotAuthenticated());
    }
  }
}
