
import 'dart:convert';

import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Login_Screen/Login_Screen.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../Constants/App_Colors.dart';
import 'package:http/http.dart' as http;

import '../../test.dart';

class forgot_screen extends StatefulWidget {
  const forgot_screen({Key? key}) : super(key: key);

  @override
  State<forgot_screen> createState() => _forgot_screenState();
}

class _forgot_screenState extends State<forgot_screen> {
  TextEditingController confirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVisible = true;
  bool isvisible = true;
  bool isChecked = false;
  bool loading = false;

  bool? Usernamevalidation;
  bool? Passvalidation;

  void handleLogin() async {
    String user = passwordController.text;
    String pass = confirmController.text;

  if (user.isEmpty) {
    setState(() {
      Usernamevalidation = true;
    });
  } else {
    setState(() {
      Usernamevalidation = false;
    });

    if (pass.isEmpty) {
      setState(() {
        Passvalidation = true;
      });
    } else {
      setState(() {
        Passvalidation = false;
      });

      // print('---->step 4  ${storage.read('email_forgot_password')}');
      const url = '${Url}reset-password';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': storage.read('email_forgot_password'),
          'password': passwordController.text,
          'password_confirmation': confirmController.text,
        },
      );
      loading = true;
      print('----------> response ${response.body}');
      final data = json.decode(response.body);

      if (data['success'] == true) {
        loading = false;
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) => const login_screen(),
          ),
        );
      } else {
        String errorMessage = data['message'][0];
        print('error :-> $errorMessage');
        // Fluttertoast.showToast(
        //   msg: errorMessage,
        //   fontSize: 16,
        //   backgroundColor: black,
        //   gravity: ToastGravity.BOTTOM,
        //   textColor: white,
        // );
        Wid_Con.toastmsgr(context: context,msg:errorMessage);
        // Handle login failure
      }
    }
  }

  }

  double getFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define font size based on screen width
    if (screenWidth <= 320) {
      return 11.0; // Small screens
    } else if (screenWidth <= 480) {
      return 14.0; // Medium screens
    } else {
      return 13.0; // Larger screens
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = getFontSize(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg_pic.png',
                ),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image.asset('assets/images/come_eat.png',height: 110),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'New Password'.tr,
                          style: TextStyle(
                              fontSize: 30, color: white, fontWeight: FontWeight.w700,fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Your New Password Must Be Different'.tr,
                          style: TextStyle(
                              fontSize: fontSize, color: white, fontWeight: FontWeight.w500,fontFamily: 'Poppins'),
                        ),
                        Text(
                          'From Previously Used Passwords.'.tr,
                          style: TextStyle(
                              fontSize: fontSize, color: white, fontWeight: FontWeight.w500,fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 15,),
                        TextFormField(
                          controller: passwordController,
                          obscureText: isVisible,
                          cursorColor: grey,
                          decoration: InputDecoration(
                            errorText: Usernamevalidation == true
                                ? 'Enter new password'
                                : null,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: white, width: 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: white, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            fillColor: white,
                            filled: true,
                            contentPadding:  EdgeInsets.symmetric(horizontal: 15,vertical: MediaQuery.of(context).size.height * 0.016),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: !isVisible
                                    ? Image.asset(
                                  'assets/images/visible_off.png',
                                  height: 15,
                                )
                                    : Image.asset('assets/images/visible_on.png',
                                    height: 15),
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: black,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12,),
                        TextFormField(
                          controller: confirmController,
                          obscureText: isvisible,
                          cursorColor: grey,
                          decoration: InputDecoration(
                            errorText: Passvalidation == true
                                ? 'Enter your confirm password'
                                : null,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: white, width: 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: white, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            fillColor: white,
                            filled: true,
                            contentPadding:  EdgeInsets.symmetric(horizontal: 15,vertical: MediaQuery.of(context).size.height * 0.016),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isvisible = !isvisible;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: !isvisible
                                    ? Image.asset(
                                  'assets/images/visible_off.png',
                                  height: 15,
                                )
                                    : Image.asset('assets/images/visible_on.png',
                                    height: 15),
                              ),
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                              color: black,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Wid_Con.button(
                          height: 50,
                          fontWeight: FontWeight.w400,
                          width: MediaQuery.of(context).size.width / 1.5,
                          ButtonName: 'Create New Password',
                          titelcolor: white,
                          onPressed: () {
                            handleLogin();

                          },
                          ButtonRadius: 5,
                          fontSize: 18,
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
