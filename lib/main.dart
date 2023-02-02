import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/styles/themes.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();




  runApp(const MyApp());
}


// ./gradlew signingReport

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      home:  LoginScreen(),
    );
  }
}


