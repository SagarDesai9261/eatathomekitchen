import 'dart:async';

import 'package:comeeathome/Pages/screens/Login_Screen/Forgot_Pass_Screen.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Constants/App_Colors.dart';
import '../../test.dart';
import '../Dashboard_screen/dashboard_screen.dart';

class email_verified extends StatefulWidget {
  const email_verified({Key? key}) : super(key: key);

  @override
  State<email_verified> createState() => _email_verifiedState();
}

class _email_verifiedState extends State<email_verified> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('-------email_forgot_password----------> ${storage.read('email_forgot_password')}');
    Timer(const Duration(milliseconds: 1000), () {
      if (storage.read('email_forgot_password') != null) {
        Navigator.push(context,
            NoBlinkPageRoute(builder: (context) => const forgot_screen()));
      }else if(storage.read('api_token_verified') != null){
        Navigator.pushReplacement(context,
            NoBlinkPageRoute(builder: (context) => const bottom_screen(pageindex: 4,isKitchen: true,)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFC73C1B),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE18D2E),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.done, size: 55),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Your Email ID Verified',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    color: blue,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 15,
            ),
            Text(
              'You will be redirected to the main page'.tr,
              style: TextStyle(
                  fontSize: 13,
                  color: blue,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins'),
            ),
            Text(
              'in a few moments'.tr,
              style: TextStyle(
                  fontSize: 13,
                  color: blue,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}
