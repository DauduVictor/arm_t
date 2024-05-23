import 'dart:async';
import 'package:arm_test/core/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.initial());

  ///Function to sign up user
  Future<void> signUp({
    required String email,
    required String password,
    bool retry = false,
  }) async {
    try {
      emit(const _Loading());
      final apiResponse = await AuthRepository().signUp(
        email: email,
        password: password,
      );
      emit(_SignUp(user: apiResponse));
    } on AuthException catch (e) {
      emit(_Error(error: e));
    }
  }

  ///Function to login user
  Future<void> signIn({
    required String email,
    required String password,
    bool retry = false,
  }) async {
    try {
      emit(const _Loading());
      final apiResponse = await AuthRepository().signIn(
        email: email,
        password: password,
      );
      emit(_SignIn(user: apiResponse));
    } on AuthException catch (e) {
      emit(_Error(error: e));
    }
  }

  ///Function to logout user
  Future<void> logout() async {
    try {
      emit(const _Loading());
      final apiResponse = await AuthRepository().logout();
      emit(_Logout(logout: apiResponse));
    } on AuthException catch (e) {
      emit(_Error(error: e));
    }
  }
}
