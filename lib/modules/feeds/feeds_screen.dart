// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 10.0,
            margin: EdgeInsets.all(8.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Image(
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://img.freepik.com/free-photo/photo-delighted-african-american-woman-points-away-with-both-index-fingers-promots-awesome-place-your-advertising-content_273609-27157.jpg'),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('communicate with friends',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                      color: Colors.white,
                      backgroundColor: secondaryColor.withOpacity(.1),
                      height: 1.0,
                    ),),
                ),
              ],
            ),

          ),
        ListView.separated(
          shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder:(context,index)=>buildPostItem(context),
            separatorBuilder: (context,index)=>SizedBox(
              height: 10.0,
            ),
            itemCount: 10,
        ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget buildPostItem(context)=>Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/young-woman-with-afro-haircut-wearing-orange-sweater_273609-22398.jpg?w=900&t=st=1675442690~exp=1675443290~hmac=c7aea7072ec4dbf5d2fe566934754c6a57ca4fa9aa3578c7a33aaf7df8419633'),
                radius: 25.0,
              ),
              SizedBox(width: 10.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Bassant waleed',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium,),
                        SizedBox(width: 5.0,),
                        Icon(Icons.check_circle,
                          color: Colors.blue,
                          size: 18.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.0,),
                    Text('june 6, 2022 at 12:00 AM',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall,),

                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz,
                size: 18.0,
              ),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              height: 2.0,
              color: secondaryColor,
            ),
          ),
          Text(
            'I would say I love you to the moon and back, but that’s pretty far—how about to the mailbox and back? All jokes aside, I’m so lucky to have you as a sibling. Happy birthday, and cheers to a wonderful year!',
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 5.0,
              bottom: 10.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 6.0,
                    ),
                    child: SizedBox(
                      height: 25.0,
                      child: MaterialButton(
                          height: 25.0,
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          child: Text('#birthday',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: (){}
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 10.0,
                    ),
                    child: SizedBox(
                      height: 25.0,
                      child: MaterialButton(
                          height: 25.0,
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          child: Text('#birthday',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: (){}
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 140.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                image: NetworkImage(
                    'https://hips.hearstapps.com/hmg-prod/images/birthday-cake-decorated-with-colorful-sprinkles-and-royalty-free-image-1653509348.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: defaultColor,
                        ),
                        Text('1200',
                          style: Theme.of(context).textTheme.titleSmall,),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Text('120 comments',
                      textAlign:TextAlign.end ,
                      style: Theme.of(context).textTheme.titleSmall,),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2.0,
            color: secondaryColor,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){},
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-photo/young-woman-with-afro-haircut-wearing-orange-sweater_273609-22398.jpg?w=900&t=st=1675442690~exp=1675443290~hmac=c7aea7072ec4dbf5d2fe566934754c6a57ca4fa9aa3578c7a33aaf7df8419633'),
                        radius: 18.0,
                      ),
                      SizedBox(width: 10.0,),
                      Text('write a comment ...',
                        textAlign: TextAlign.start,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleSmall,),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 1.0,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconBroken.Heart,
                      color: defaultColor,
                      size: 18.0,
                    ),
                    Text(' Like',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall,),
                  ],
                ),),
              MaterialButton(
                onPressed: () {},
                minWidth: 1.0,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share,
                      color: secondaryColor,
                      size: 18.0,
                    ),
                    Text(' Share',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall,),
                  ],
                ),),

            ],
          ),

        ],
      ),
    ),

  );

}
