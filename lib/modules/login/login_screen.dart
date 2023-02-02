// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/login/cubit/login_states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is ErrorLoginState){
            showToast(message: state.error, state: ToastState.error);
          }
        },
        builder: (context, state) {
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
                        Text(
                          'LOGIN',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
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
                          labelText: 'Password',
                          prefix: Icons.email_outlined,
                          isPassword: LoginCubit
                              .get(context)
                              .isPassword,
                          suffix: LoginCubit
                              .get(context)
                              .isPassword
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
                          builder: (context) =>
                              defaultButton(
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
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Don\'t have account?',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelMedium,
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
