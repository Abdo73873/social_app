// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/Home/home_layout.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/new_post/cubit/posts_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

void requestPermissions()async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  showToast(message: 'on BackGround message', state: ToastState.success);


}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
    await CacheHelper.init();
  await Firebase.initializeApp();
  deviceToken=await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data['id'].toString());
    print('=============================\n');
    print(event.notification?.body);
    showToast(message: 'on message', state: ToastState.success);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(message: 'on open App message', state: ToastState.success);

  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  requestPermissions();
  FirebaseMessaging.instance.onTokenRefresh.listen((event) { });
  FirebaseMessaging.instance.subscribeToTopic('requestsNotification');
  FirebaseMessaging.instance.unsubscribeFromTopic('requestsNotification');

  print(deviceToken);
  bool? isDark= CacheHelper.getData(key: 'isDark',);
   myId =CacheHelper.getData(key: "uId");
   Widget startWidget;
    if(myId!=null){
      startWidget=HomeLayout();
    }else {startWidget=LoginScreen();}


  runApp( MyApp(startWidget,isDark));
}


// ./gradlew signingReport

class MyApp extends StatelessWidget {
   Widget startWidget;
   bool? isDark;
  MyApp(this.startWidget,this.isDark);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
        create: (context)=>HomeCubit()
          ..getMyData()
          ..getPosts(20)
          ..changeMode(fromCache: isDark),
        ),
        BlocProvider(
        create: (context)=>ProfileCubit()
        ),
        BlocProvider(
        create: (context)=>PostsCubit(),
        ),
        BlocProvider(
          create: (context)=>UsersCubit()
            ..getUsersData()
            ..streamFriends(),
        ),
      ],
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,states){},
        builder: (context,states){
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: HomeCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}


