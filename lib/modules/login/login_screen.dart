// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/home_layout.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/login/cubit/login_states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController=ScrollController();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is SuccessesLoginState) {
            CacheHelper.saveData(key: "uId", value:myId).then((value) {
              HomeCubit.get(context).getMyData();
              HomeCubit.get(context).changeBottomScreen(0);
              bool? isDark= CacheHelper.getData(key: 'isDark',);
              navigateAndFinish(context, MyApp(HomeLayout(),isDark));
            });
          }
          if (state is ErrorLoginState) {
            showToast(message: state.error.split(']')[1], state: ToastState.error);
          }
          if (state is LoginResetPasswordSuccessState){
            showToast(message:'check your email', state: ToastState.success);
          }
          if (state is LoginResetPasswordErrorState){
            showToast(message:state.error, state: ToastState.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child:!LoginCubit.get(context).forgotPassword
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.0,),
                      if(!HomeCubit.get(context).isDark)
                      Center(
                        child: Image(
                          width: 150.0,
                          height: 150.0,
                          image: AssetImage('assets/images/lightLogo.jpg',),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if(HomeCubit.get(context).isDark)
                        Center(
                          child: Image(
                            width: 150.0,
                            height: 150.0,
                            image: AssetImage('assets/images/darkLogo.JPG',),
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 50.0,),
                      Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Login now to communicate with friends',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: 40.0,
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
                        onTap: (){
                            scrollController.jumpTo(scrollController.position.maxScrollExtent-100);
                            LoginCubit.get(context).jumpTo();

                        },
                      ),
                      SizedBox(
                        height: 20.0,
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
                        onTap: (){
                          scrollController.jumpTo(scrollController.position.maxScrollExtent-100);
                          LoginCubit.get(context).jumpTo();

                        },
                        labelText: 'Password',
                        prefix: Icons.email_outlined,
                        isPassword: LoginCubit.get(context).isPassword,
                        suffix: LoginCubit.get(context).isPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        suffixOnPressed: () {
                          LoginCubit.get(context).changeVisibility();
                        },
                        onSubmit: (value) {
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        action: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoadingLoginState,
                        builder: (context) => defaultTextMatrialButton(
                          context: context,
                          text: 'Login',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).loginUser(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      if(state is ErrorLoginState||state is LoginChangeForgotPasswordState)
                      Row(
                        children: [
                          Text('Forgot your Password?'),
                          SizedBox(width: 10.0,),
                          OutlinedButton(
                            onPressed: (){
                              LoginCubit.get(context).changeForgotPassword();
                            },
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),),),
                              side: MaterialStatePropertyAll(BorderSide(color: secondaryColor),),
                            ),
                            child: Text('Reset',style:Theme.of(context).textTheme.bodyMedium),),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'Don\'t have account?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          defaultText(
                            text: 'REGISTER',
                            onPressed: () {
                              navigateAndReplace(context, RegisterScreen());
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                :Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 100,),
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
                      hintText: 'Enter Your Email Address',
                      prefix: Icons.email_outlined,
                      action: TextInputAction.done,
                      onTap: (){
                      LoginCubit.get(context).resetPassword(email: emailController.text);
                      },
                    ),
                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: (){
                            LoginCubit.get(context).changeForgotPassword();
                          },
                            style: ButtonStyle(
                              side: MaterialStatePropertyAll(BorderSide(color: secondaryColor)),
                            ),
                            child: Text('back to login',style:Theme.of(context).textTheme.bodyMedium),),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: (){
                              LoginCubit.get(context).resetPassword(email: emailController.text);
                            },
                            child: Text('Send'),
                          ),

                        ],
                      ),
                    ],
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
