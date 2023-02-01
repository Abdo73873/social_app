
abstract class LoginStates{}
class InitializeLoginState extends LoginStates{}
class LoadingLoginState extends LoginStates{}
class SuccessesLoginState extends LoginStates{}
class ErrorLoginState extends LoginStates{
  final String error;
  ErrorLoginState(this.error);

}
class ChangeVisibilityState extends LoginStates{}
class ChangeLanguageState extends LoginStates{}
