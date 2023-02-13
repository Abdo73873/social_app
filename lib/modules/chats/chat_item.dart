// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatItemScreen extends StatelessWidget {
  late UserModel friend;

  ChatItemScreen(this.friend);

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int limit = 20;
  bool refresh = false;

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getMessage(friend.uId, 20);

    return RefreshIndicator(
      onRefresh: () {
        limit += 20;
        refresh = true;
        return Future(() {
          HomeCubit.get(context).getMessage(friend.uId, limit);
        });
      },
      child: Builder(
        builder: (context) {
          return BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              if(!refresh){
                if (scrollController.hasClients) {
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                }
              }
              refresh=false;
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: friend.image,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/person.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        friend.name,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  ListView.separated(
                                    itemBuilder: (context, index) {
                                      if (cubit.messages[index].senderId == myId) {
                                        return buildMyMessage(
                                            context, cubit.messages[index]);
                                      }
                                      return buildMessage(cubit.messages[index]);
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: 10.0,
                                    ),
                                    itemCount: cubit.messages.length,
                                    physics: BouncingScrollPhysics(),
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    dragStartBehavior:DragStartBehavior.down ,

                                  ),
                                      if (scrollController.hasClients)
                                  if(scrollController.offset<=scrollController.position.maxScrollExtent-20.0)
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: IconButton(onPressed:(){
                                  if (scrollController.hasClients) {
                                    scrollController.animateTo(
                                        scrollController.position
                                            .maxScrollExtent,
                                        duration: Duration(seconds: 2),
                                        curve: Curves.linear).then((value){
                                      cubit.typing();
                                    });
                                  }
                                }, icon: Icon(
                                  Icons.arrow_downward,
                                size: 50.0,
                                  color: defaultColor,
                                ),),
                              ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state is! HomeChatUploadImageLoadingState)
                      if (cubit.chatImage != null)
                        Center(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Image.file(
                                cubit.chatImage!,
                                height: 200,
                                width: double.infinity,
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.removeImage();
                                },
                                icon: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: defaultColor,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    if (!cubit.isUploadCompleted) CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 20.0,
                        horizontal: 5.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (messageController.text.isEmpty)
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(.9),
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(10.0),
                                  bottomStart: Radius.circular(10.0),
                                ),
                                border: Border.all(),
                              ),
                              child: Row(
                                children: [
                                  MaterialButton(
                                    padding: EdgeInsetsDirectional.all(.8),
                                    minWidth: 1,
                                    onPressed: () {
                                      cubit.getImage(false);
                                    },
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 25.0,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                  MaterialButton(
                                    padding: EdgeInsetsDirectional.all(.8),
                                    minWidth: 1,
                                    onPressed: () {
                                      cubit.getImage(true);
                                    },
                                    child: Icon(
                                      IconBroken.Image,
                                      size: 25.0,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Expanded(
                            child: SizedBox(
                              height:
                                  messageController.text.isEmpty ? 50.0 : null,
                              child: TextFormField(
                                onChanged: (value) {
                                  HomeCubit.get(context).typing();
                                },
                                controller: messageController,
                                minLines: 1,
                                maxLines: 4,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textInputAction: TextInputAction.newline,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(1),
                                  border: OutlineInputBorder(),
                                  hintText: ' type your message here...',
                                  hintStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 45.0,
                            decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadiusDirectional.only(
                                topEnd: Radius.circular(10.0),
                                bottomEnd: Radius.circular(10.0),
                              ),
                              border: Border.all(),
                            ),
                            child: MaterialButton(
                              minWidth: 1,
                              padding: EdgeInsetsDirectional.all(.8),
                              onPressed: () {
                                if (cubit.chatImage != null) {
                                  cubit.uploadImage(
                                    receiverId: friend.uId,
                                    text: messageController.text,
                                  );
                                  cubit.isUploadCompleted == false;
                                } else {
                                  cubit.sendMessage(
                                      receiverId: friend.uId,
                                      text: messageController.text);
                                }
                                messageController.clear();
                              },
                              child: Icon(
                                Icons.send,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(15.0),
              topStart: Radius.circular(15.0),
              topEnd: Radius.circular(15.0),
            ),
          ),
          child: Text(message.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              )),
        ),
      );

  Widget buildMyMessage(context, MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: HomeCubit.get(context).isDark
                ? defaultColor.withOpacity(.4)
                : defaultColor.withOpacity(0.2),
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(15.0),
              topStart: Radius.circular(15.0),
              topEnd: Radius.circular(15.0),
            ),
          ),
          child: Column(
            children: [
              if (message.image != null)
                if (message.image!.isNotEmpty)
                  CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        CircularProgressIndicator(),
                    imageUrl: message.image!,
                    height: 400,
                    width: 400,
                    errorWidget: (context, url, error) =>
                        Center(child: CircularProgressIndicator()),
                  ),
              Text(message.text,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
            ],
          ),
        ),
      );
}
