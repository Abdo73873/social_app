// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:social_app/models/generalDetails_model.dart';
import 'package:social_app/modules/settings/general_details.dart';
import 'package:social_app/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
 GeneralDetailsModel? details;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 190.0,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                      width: double.infinity,
                      height: 140.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://img.freepik.com/free-photo/photo-delighted-african-american-woman-points-away-with-both-index-fingers-promots-awesome-place-your-advertising-content_273609-27157.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/young-woman-with-afro-haircut-wearing-orange-sweater_273609-22398.jpg?w=900&t=st=1675442690~exp=1675443290~hmac=c7aea7072ec4dbf5d2fe566934754c6a57ca4fa9aa3578c7a33aaf7df8419633'),
                      radius: 60.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Text('Bassant waleed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5.0,),
            Text('bio ...',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('100',style: Theme.of(context).textTheme.bodyMedium,),
                        Text('post',style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('100',style: Theme.of(context).textTheme.bodyMedium,),
                        Text('follower',style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('100',style: Theme.of(context).textTheme.bodyMedium,),
                        Text('following',style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('100',style: Theme.of(context).textTheme.bodyMedium,),
                        Text('friends',style: Theme.of(context).textTheme.bodySmall,),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: defaultButton(context: context, text: 'Edit Profile', onPressed: (){}),
            ),
            SizedBox(height: 10.0,),
            /*
            SizedBox(
              width: double.infinity,
              height: 200,
              child: generalDetails(context,details),
            ),
*/
          ],
        ),
      ),
    );
  }
}
