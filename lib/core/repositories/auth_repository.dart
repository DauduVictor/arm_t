import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/// {@template auth_repository_exception}
/// General exception for [AuthRepository] methods.
/// {@endtemplate}
class AuthException implements Exception {
  /// {@macro host_repository_exception}
  const AuthException({String? message})
      : message = message ?? 'Something went wrong';

  /// Error message.
  final String? message;

  @override
  String toString() => message!;
}

/// {@template auth_repository}
/// Auth repository interacts firebase apis.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  AuthRepository();

  /// Sign up user
  ///
  /// Returns [User] on success.
  /// Throws [AuthException] when operation fails.
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  /// Sign in user
  ///
  /// Returns [User] on success.
  /// Throws [AuthException] when operation fails.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  /// Logout user
  ///
  /// Returns [bool] on success.
  /// Throws [AuthException] when operation fails.
  Future<bool> logout() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      return true;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
}
