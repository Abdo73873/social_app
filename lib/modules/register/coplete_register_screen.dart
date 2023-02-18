// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/home_layout.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/register/register_cubit/register_cubit.dart';
import 'package:social_app/modules/register/register_cubit/register_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class CompleteRegister extends StatelessWidget {
  TextEditingController schoolController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController liveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                OutlinedButton(onPressed:(){
                  bool isDark=CacheHelper.getData(key: 'isDark');
                  navigateAndFinish(context, MyApp(HomeLayout(), isDark));
                }, child: Text('Skip')),
                SizedBox(width: 10.0,),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Details',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    defaultFromField(
                      context: context,
                      controller: schoolController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return null;
                      },
                      hintText: 'where are you Studying? ...',
                      prefix: Icons.school,
                      action: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultFromField(
                      context: context,
                      controller: workController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return null;
                      },
                      prefix: Icons.work_outline,
                      action: TextInputAction.next,
                      hintText: 'where are you Working? ...'
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultFromField(
                        context: context,
                        controller: countryController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null;
                        },
                        prefix: Icons.home_work_outlined,
                        action: TextInputAction.next,
                        hintText: 'where are you from? ...'

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFromField(
                        context: context,
                        controller: liveController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null;
                        },
                        prefix: Icons.place,
                        action: TextInputAction.next,
                        hintText: 'where are you living? ...'

                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  Center(
                    child: ToggleButtons(
                        selectedColor: defaultColor,
                        borderRadius: BorderRadius.circular(20.0),
                        borderWidth: 3.0,
                        borderColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                        selectedBorderColor: defaultColor,
                        color: Theme.of(context).iconTheme.color,
                        splashColor: defaultColor,
                        highlightColor: defaultColor,
                        disabledBorderColor: secondaryColor,
                        disabledColor: Colors.white,
                        isSelected:RegisterCubit.get(context).choose,
                        onPressed: (index){
                          RegisterCubit.get(context).chooseStatus(index);
                        },
                        children:[
                          Text('     Single     '),
                          Text('     Engaged     '),
                          Text('     Married     '),

                    ]
                    ),
                  ),
                    SizedBox(
                      height: 100.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingRegisterState,
                      builder: (context) => defaultTextMatrialButton(
                        context: context,
                        text: 'Start',
                        onPressed: () {
                          RegisterCubit.get(context).completeData(
                            school: schoolController.text,
                            work: workController.text,
                            country: countryController.text,
                            live: liveController.text,
                            status: RegisterCubit.get(context).choose[0]
                                ?'Single'
                                :RegisterCubit.get(context).choose[1]
                                ?'Engaged'
                                :'Married'
                          );
                          bool isDark=CacheHelper.getData(key: 'isDark');
                         navigateAndFinish(context, MyApp(HomeLayout(), isDark));
                        },
                      ),
                      fallback: (context) => Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

  }
}
