import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<HomeStates>{
  HomeCubit():super(ProfileInitializeState());
  static HomeCubit get(context)=>BlocProvider.of(context);
