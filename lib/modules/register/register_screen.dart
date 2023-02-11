// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/register_cubit/register_cubit.dart';
import 'package:social_app/modules/register/register_cubit/register_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is SuccessesCreateUserState){
              CacheHelper.saveData(key: "uId", value:userId).then((value) {
                HomeCubit.get(context).getUserData();
                HomeCubit.get(context).changeBottomScreen(0);
                navigateAndFinish(context, HomeLayout());
              });
          }
          if(state is ErrorRegisterState){
            showToast(message: state.error, state: ToastState.error);
          }
        },
        builder: (context, state) {
          bool isMale=RegisterCubit.get(context).isMale;
          return Scaffold(
            appBar: AppBar(
              actions: [],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image(
                            width: 90.0,
                            height: 90.0,
                            image: AssetImage('assets/images/logo.png',),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Register now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFromField(
                          context: context,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Name';
                            }
                            return null;
                          },
                          labelText: 'User Name',
                          prefix: Icons.person,
                          action: TextInputAction.next,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultFromField(
                          context: context,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                          labelText: 'Email Address',
                          prefix: Icons.email_outlined,
                          action: TextInputAction.next,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultFromField(
                          context: context,
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Phone';
                            }
                            return null;
                          },
                          labelText: 'Phone',
                          prefix: Icons.phone_android,
                          action: TextInputAction.next,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10.0,),
                            Icon(Icons.accessibility,),
                            SizedBox(width: 10.0,),
                            Text("Gender :",
                          style: Theme.of(context).textTheme.bodyMedium,),
                          SizedBox(width: 30.0,),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: defaultColor.withOpacity(0.05),
                                border:Border.all(
                                  color: defaultColor,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: DropdownButton(
                                  value: isMale,
                                  borderRadius: BorderRadius.circular(30.0),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                  items:[
                                DropdownMenuItem(
                                  value: true,
                                  child:Row(
                                    children: [
                                      Icon(Icons.male,
                                          color: isMale?defaultColor:secondaryColor,
                                      ),
                                      SizedBox(width: 10.0,),
                                      Text('male',
                                        style: TextStyle(
                                          color: isMale?defaultColor:secondaryColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ],
                                  ) ,
                                  onTap: (){
                                    RegisterCubit.get(context).changeGender(true);
                                  },
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child:Row(
                                    children: [
                                      Icon(Icons.female,
                                        color: isMale?secondaryColor:defaultColor,
                                      ),
                                      SizedBox(width: 10.0,),
                                      Text('Female',
                                        style: TextStyle(
                                          color: isMale?secondaryColor:defaultColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ],
                                  ) ,
                                  onTap: (){
                                    RegisterCubit.get(context).changeGender(false);
                                  },

                                ),
                              ], onChanged: (value){}),
                            ),
                          ),
                        ],),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultFromField(
                            context: context,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your Password';
                              }
                              return null;
                            },
                            labelText: 'Password',
                            prefix: Icons.email_outlined,
                            isPassword: RegisterCubit.get(context).isPassword,
                            action: TextInputAction.done,
                            suffix: RegisterCubit.get(context).isPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            suffixOnPressed: () {
                              RegisterCubit.get(context).changeVisibility();
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  isMale: isMale,
                                );
                              }
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingRegisterState,
                          builder: (context) => defaultTextMatrialButton(
                            context: context,
                            text: 'Register',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  isMale: isMale,
                                );
                              }
                            },
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Do have account?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            defaultText(
                              text: 'LOGIN',
                              onPressed: () {
                                navigateAndReplace(context, LoginScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
