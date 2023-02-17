// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/colors.dart';

Widget defaultTextMatrialButton({
  double width = double.infinity,
  double radius = 30.0,
  required BuildContext context,
  Color? background=defaultColor,
  bool isUppercase = true,
  required String text,
  required Function() onPressed,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUppercase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFromField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType keyboardType,
  Function(String)? onSubmit,
  Function(String)? onChange,
  required String? Function(String?) validator,
  required String labelText,
  IconData? prefix,
  IconData? suffix,
  Function()? suffixOnPressed,
  Function()? onTap,
  bool isPassword = false,
  TextInputAction? action,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validator,
      onTap: onTap,
      obscureText: isPassword,
      decoration: InputDecoration(
        fillColor: defaultColor.withOpacity(.05),
        filled: true,
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          gapPadding: 20.0,
        ),

        prefixIcon: prefix != null
            ? Icon(
                prefix,
              )
            : null,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                ),
                onPressed: suffixOnPressed,
              )
            : null,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: secondaryColor,
            )
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      textDirection: TextDirection.ltr,
      textInputAction: action,
    );

Widget defaultText({
  required String text,
  required Function()? onPressed,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
      ),
    );


PreferredSizeWidget defaultAppBar({
  required BuildContext context,
   String? title,
  required List<Widget> actions,
}) => AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
      ),
  title: Text(title??''),
  actions: actions,
    );

void navigateTo(context, Widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Widget),
    );

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Widget,
    ),
    (route) => false);

void navigateAndReplace(context, Widget) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => Widget));

void showToast({
  required String message,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastState { success, error, warning }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.success:
      color = Colors.green;
      break;
    case ToastState.error:
      color = Colors.red;
      break;
    case ToastState.warning:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget separated() => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[300],
      ),
    );
