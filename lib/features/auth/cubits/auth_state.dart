part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.signUp({
    required User? user,
  }) = _SignUp;
  const factory AuthState.signIn({
    required User? user,
  }) = _SignIn;
  const factory AuthState.logout({
    required bool logout,
  }) = _Logout;
  const factory AuthState.error({
    required Exception error,
  }) = _Error;
}
