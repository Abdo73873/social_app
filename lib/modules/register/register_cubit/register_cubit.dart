import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/modules/register/register_cubit/register_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/shared/components/constants.dart';

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
      email: email,
      password: password,
    ).then((value) {
      createUser(
          name: name,
          email: email,
          uId: value.user!.uid,
          phone: phone
      );
    }).catchError((error) {
      emit(ErrorRegisterState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String uId,
    required String phone,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      uId: uId,
      phone: phone,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance.collection("users").doc(uId).set(model.toMaP())
        .then((value){
      uIdUser=uId;
      emit(SuccessesCreateUserState());
    }).catchError((error){
      emit(ErrorCreateUserState(error.toString()));
    });

  }
}
