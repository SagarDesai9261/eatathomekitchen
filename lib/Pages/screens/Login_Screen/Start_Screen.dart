import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Login_Screen/Register_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Constants/App_Colors.dart';

import '../../test.dart';
import 'Login_Screen.dart';

class start_screen extends StatefulWidget {
  const start_screen({Key? key}) : super(key: key);

  @override
  State<start_screen> createState() => _start_screenState();
}

class _start_screenState extends State<start_screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child:
                        Image.asset('assets/images/come_eat.png', height: 110),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Welcome Eat At Home Your Favorite'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  Text(
                    'Foods Delivered Fast at Your Door.'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  const Spacer(),
                  Wid_Con.button(
                    ButtonName: 'Get Started',
                    onPressed: () {
                      Navigator.push(
                          context,
                          NoBlinkPageRoute(
                              builder: (context) => const login_screen()));
                    },
                    ButtonColor: white,
                    ButtonRadius: 100,
                    height: 52,
                    width: MediaQuery.of(context).size.width / 2,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 0.3,
                          color: white,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Sign in with',
                        style: TextStyle(
                            color: white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 0.3,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wid_Con.button(
                        ButtonName: ' ',
                        onPressed: () {},
                        ButtonColor: white,
                        ButtonRadius: 100,
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          'assets/images/facebook.png',
                          height: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Wid_Con.button(
                        ButtonName: ' ',
                        onPressed: () {},
                        ButtonColor: white,
                        ButtonRadius: 100,
                        width: 60,
                        height: 60,
                        child:
                            Image.asset('assets/images/google.png', height: 30),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          NoBlinkPageRoute(
                              builder: (context) => const register_screen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account? ',
                          style: TextStyle(
                              fontSize: 14,
                              color: white,
                              fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 14,
                              color: red,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
