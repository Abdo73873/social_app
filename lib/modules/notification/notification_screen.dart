import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/layout/Home/home_layout.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/user_layout.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/modules/users/all_users_screen.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

void sendToFireStore({
  required String name,
  required String uId,
  required String image,
  required String title,
  required String message,
  required String dateTime,
}) {
  NotificationModel model = NotificationModel(
      name: name,
      uId: uId,
      image: image,
      title: title,
      message: message,
      dateTime: dateTime);
  FirebaseFirestore.instance
      .collection('users')
      .doc(myId)
      .collection('notification')
      .add(model.toMaP());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['id']!=myId){
    sendToFireStore(
      name: message.data['name'],
      uId: message.data['id'],
      image: message.data['image'],
      title: message.notification!.title!,
      message: message.notification!.body!,
      dateTime: DateFormat.yMd().add_jms().format(message.sentTime!).toString(),
    );
}

}

Future<void> firebaseMessaging(RemoteMessage message) async {
  if (message.data['id']!=myId){
    sendToFireStore(
      name: message.data['name'],
      uId: message.data['id'],
      image: message.data['image'],
      title: message.notification!.title!,
      message: message.notification!.body!,
      dateTime: DateFormat.yMd().add_jms().format(message.sentTime!).toString(),
    );
  }


}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).streamNotification();
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit =HomeCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            titleSpacing: 0,
            title: const Text('Notification'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: OutlinedButton(
                  style:const ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    ),
                    fixedSize: MaterialStatePropertyAll(Size.zero),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    side: MaterialStatePropertyAll(BorderSide(width: 1,color: defaultColor)),
                  ) ,

                  onPressed: (){
                    cubit.clearNotification();
                  }, child:const Text('clear'),),
              ),
              const SizedBox(width: 10.0,),
              Padding(
                padding: const EdgeInsets.all( 8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 8.0,
                        end: 20.0,
                      ),
                      child: Icon(IconBroken.Notification,),
                    ),
                    CircleAvatar(
                      radius: 12,
                      child:Text(cubit.notify.length<=9?'${cubit.notify.length}':'+9',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),) ,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30.0,),

            ],
          ),
          body: cubit.notify.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return buildNotifyItem(context, cubit.notify[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20.0,
                    ),
                    itemCount: cubit.notify.length,
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }

  Widget buildNotifyItem(context, NotificationModel model) => InkWell(
    onTap: (){
      if(model.title.substring(0,4)=='Send'){
        HomeCubit.get(context).changeBottomScreen(3);
        UsersCubit.get(context).changeUsersBottomScreen(2);
        navigateAndReplace(context, HomeLayout());
      }
      if(model.title.substring(0,8)=='Accepted'){
        for(int i=0;i<UsersCubit.get(context).users.length;i++) {
          if(UsersCubit.get(context).users[i].uId==model.uId) {
          navigateAndReplace(context, UserProfileScreen(UsersCubit.get(context).users[i]));
        }
        }
      }
      if(model.title.substring(0,9)=='Published'){
        HomeCubit.get(context).changeBottomScreen(0);
        navigateAndReplace(context, HomeLayout());
      }



    },
    child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              child: ClipOval(
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: model.image,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/person.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    '${model.title} '
                    '${model.message}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                model.dateTime,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12.0),
              ),
                ],
              ),
            ),
          ],
        ),
  );
}
