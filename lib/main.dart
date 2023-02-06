// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
    await CacheHelper.init();
  await Firebase.initializeApp();
  bool? isDark= CacheHelper.getData(key: 'isDark',);

   userId =CacheHelper.getData(key: "uId");
   Widget startWidget;
    if(userId!=null){
      startWidget=HomeLayout();
    }else {startWidget=LoginScreen();}


  runApp( MyApp(startWidget));
}


// ./gradlew signingReport

class MyApp extends StatelessWidget {
   Widget startWidget;
  MyApp(this.startWidget);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
        create: (context)=>HomeCubit()..getUserData(),
        ),
        BlocProvider(
        create: (context)=>ProfileCubit(),
        ),
      ],
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,states){},
        builder: (context,states){
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}


