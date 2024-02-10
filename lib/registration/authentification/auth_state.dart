abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {}

class AuthenticationFailed extends AuthState {
  String message;
  AuthenticationFailed(this.message);
}

class LoggedOut extends AuthState {}
