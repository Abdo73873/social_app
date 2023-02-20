
abstract class LoginStates{}
class InitializeLoginState extends LoginStates{}
class LoadingLoginState extends LoginStates{}
class SuccessesLoginState extends LoginStates{
  SuccessesLoginState();
}
class ErrorLoginState extends LoginStates{
  final String error;
  ErrorLoginState(this.error);

}

class SuccessesPushTokenState extends LoginStates{}

class ChangeVisibilityState extends LoginStates{}

class JumpToState extends LoginStates{}
class LoginChangeForgotPasswordState extends LoginStates{}
class LoginResetPasswordSuccessState extends LoginStates{}
class LoginResetPasswordErrorState extends LoginStates{
  final String error;
  LoginResetPasswordErrorState(this.error);
}
