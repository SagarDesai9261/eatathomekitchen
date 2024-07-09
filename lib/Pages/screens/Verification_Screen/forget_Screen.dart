
import 'dart:convert';
import 'dart:developer';

import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Verification_Screen/email_verification.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/App_Colors.dart';
import 'package:http/http.dart' as http;

import '../../test.dart';
import '../Login_Screen/Start_Screen.dart';

class email_screen extends StatefulWidget {
  const email_screen({Key? key}) : super(key: key);

  @override
  State<email_screen> createState() => _email_screenState();
}

class _email_screenState extends State<email_screen> {

  TextEditingController emailController = TextEditingController();
  bool loading = false;
  bool? Usernamevalidation;

  void emailverify() async {
    try {
      loading = true;
      const url = '${Url}forgot-password';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email' : emailController.text,
        },
      );

      storage.write('email_forgot_password', emailController.text);

      final data = json.decode(response.body);
      print('$data');

      if(response.statusCode==200||response.statusCode==201) {
        if (data['success'] == true) {
          setState(() {
            loading = false;
          });

          // ignore: use_build_context_synchronously
          Navigator.push(context,
              NoBlinkPageRoute(builder: (context) =>  emails_screen(email: emailController.text,type: 'Forgot Password',)));

        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');

          // Handle login failure
        }
      }else if(response.statusCode==401||response.statusCode==400){
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) => const start_screen(),
          ),
        );
        storage.remove('email_verified');
        storage.remove('api_token_login');
      }


    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrrrrrrrrrrrrrrrrrrr: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

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
                        'Forgot Password'.tr,
                        style: TextStyle(
                            fontSize: 30, color: white, fontWeight: FontWeight.w700,fontFamily: 'Poppins'),
                      ),

                      const SizedBox(height: 15,),
                      TextFormField(
                        controller: emailController,
                        cursorColor: grey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
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
                          errorText: Usernamevalidation == false
                              ? 'Enter your Email'
                              : null,
                          fillColor: white,
                          filled: true,
                          contentPadding:  EdgeInsets.symmetric(horizontal: 15,vertical: MediaQuery.of(context).size.height * 0.016),
                          hintText: 'Email ID',
                          hintStyle: TextStyle(
                            color: black,
                            fontSize: MediaQuery.of(context).size.width * 0.045,
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
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Center( child:loading==false? Text('Get OTP',style: TextStyle(
                            color: white,
                            fontSize:  18,
                            fontWeight:  FontWeight.w400,
                            fontFamily: 'Poppins'),):Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircularProgressIndicator(color: white,),
                        )),
                        titelcolor: white,
                        onPressed: () {
                          if(emailController.text.isEmpty) {
                            setState(() {
                              Usernamevalidation = false;
                            });
                          }
                          else{
                            setState(() {
                              Usernamevalidation = true;
                             emailverify();
                            });
                          }
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
