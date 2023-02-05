import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import 'package:social_app/shared/components/constants.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() :super(ProfileInitializeState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  List<bool> readOnly=[
    true,true, true,true,true,
  ];

  void changeOpenEdit(int index){
    readOnly[index]=! readOnly[index];
    emit(ProfileOpenEditState());
  }

  void changeToAdd({
    required BuildContext context,
    bool? isEditScreen
}){
    if(isEditScreen!=null){
      if(isEditScreen){
        openToAdd=true;
      }else if(!isEditScreen) {openToAdd=false;}

    } else {
      openToAdd=! openToAdd;
    }
    emit(ProfileOpenEditState());
  }


}