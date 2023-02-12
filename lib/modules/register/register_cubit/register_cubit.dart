import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/userModel.dart';
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
  bool isMale=true;
  void changeGender(bool gender) {
    isMale = gender;
    emit(ChangeGenderState());
  }


  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    required bool isMale,
    String? bio,
     String? image,
     String? cover,
    GeneralDetailsModel? generalDetailsModel,
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
          phone: phone,
          male: isMale,
          bio: bio,
        image: image,
        cover: cover,
        generalDetailsModel:generalDetailsModel,
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
    required bool male,
    String? bio,
    String? image,
    String? cover,
   GeneralDetailsModel? generalDetailsModel,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      uId: uId,
      phone: phone,
      male: male,
      bio: bio,
      image: image??(male?'https://firebasestorage.googleapis.com/v0/b/social-app-644bc.appspot.com/o/users%2Fsystem%2Fmale.jpg?alt=media&token=56c9aae6-6c3d-471a-8179-56edfd833e8f'
      :'https://firebasestorage.googleapis.com/v0/b/social-app-644bc.appspot.com/o/users%2Fsystem%2Ffemale.jpg?alt=media&token=017d7bd7-080e-476e-ba0c-53f8af8a19b2'),


      cover: cover,
      isEmailVerified: false,
    generalDetails: generalDetailsModel,
    );
    FirebaseFirestore.instance.collection("users").doc(uId).set(model.toMaP())
        .then((value){
      myId=uId;
      emit(SuccessesCreateUserState());
    }).catchError((error){
      emit(ErrorCreateUserState(error.toString()));
    });

  }
}
