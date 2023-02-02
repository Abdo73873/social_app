import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/register_cubit/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitializeRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  void changeVisibility() {
    isPassword = !isPassword;
    emit(ChangeVisibilityState());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(LoadingRegisterState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password,).then(
            (value) {
          emit(SuccessesRegisterState());
    }).catchError((error){
      emit(ErrorRegisterState(error.toString()));
    });
  }

}
