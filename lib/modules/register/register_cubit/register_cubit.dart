import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/register_cubit/register_states.dart';

 class RegisterCubit extends Cubit<RegisterStates>{
   RegisterCubit():super(InitializeRegisterState());
   static RegisterCubit get(context)=>BlocProvider.of(context);

   bool isPassword=true;
   void changeVisibility(){
     isPassword=!isPassword;
     emit(ChangeVisibilityState());
   }



 }

