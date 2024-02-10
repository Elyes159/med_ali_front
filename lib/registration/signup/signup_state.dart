abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpmitting extends SignUpState {}

class SignUpsuccess extends SignUpState {}

class SignUpFailed extends SignUpState {
  String message;
  SignUpFailed(this.message);
}
