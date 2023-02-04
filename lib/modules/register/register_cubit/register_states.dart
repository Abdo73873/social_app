
abstract class RegisterStates{}
class InitializeRegisterState extends RegisterStates{}
class LoadingRegisterState extends RegisterStates{}
class SuccessesRegisterState extends RegisterStates{}
class ErrorRegisterState extends RegisterStates{
  final String error;
  ErrorRegisterState(this.error);

}
class SuccessesCreateUserState extends RegisterStates{}
class ErrorCreateUserState extends RegisterStates{
  final String error;
  ErrorCreateUserState(this.error);

}
class ChangeVisibilityState extends RegisterStates{}
class ChangeGenderState extends RegisterStates{}
class ChangeLanguageState extends RegisterStates{}
