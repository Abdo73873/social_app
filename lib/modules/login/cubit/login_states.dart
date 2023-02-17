
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
class ChangeLanguageState extends LoginStates{}

class JumpToState extends LoginStates{}
