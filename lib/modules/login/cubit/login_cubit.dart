import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/login_states.dart';


 class LoginCubit extends Cubit<LoginStates>{
   LoginCubit():super(InitializeLoginState());
   static LoginCubit get(context)=>BlocProvider.of(context);

   bool isPassword=true;
   void changeVisibility(){
     isPassword=!isPassword;
     emit(ChangeVisibilityState());

   }



 }