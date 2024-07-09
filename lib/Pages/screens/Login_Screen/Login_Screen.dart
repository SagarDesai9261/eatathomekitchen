



import 'dart:convert';
import 'dart:developer';

import 'package:comeeathome/Constants/App_Colors.dart';

import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Verification_Screen/forget_Screen.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../../main.dart';
import '../../test.dart';
import '../Verification_Screen/email_verification.dart';
import '../Phone_verify_screen/phone_verification.dart';
import 'Forgot_Pass_Screen.dart';
import 'Register_Screen.dart';
import 'package:http/http.dart' as http;

class login_screen extends StatefulWidget {
  const login_screen({Key? key, this.isnotvalid, this.validEmail}) : super(key: key);
final isnotvalid;
final validEmail;
  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVisible = true;
  bool isChecked = false;

  double getFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define font size based on screen width
    if (screenWidth <= 320) {
      return 11.0; // Small screens
    } else if (screenWidth <= 480) {
      return 11.0; // Medium screens
    } else {
      return 12.0; // Larger screens
    }
  }

  bool? Usernamevalidation;
  bool? Passvalidation;
  bool loading = false;
  String Device_token = "";
  String email_verify = '';


  void handleLogin() async {
    String user = emailController.text;
    String pass = passwordController.text;
    if (user.isEmpty) {
      Usernamevalidation = true;
    } else {
      Usernamevalidation = false;
      if (pass.isEmpty) {
        Passvalidation = true;
      } else {
        Passvalidation = false;
        setState(() {
          loading = true;
        });

        const url = '${Url}login';
        final perams = {
          'email': emailController.text,
          'device_token': Device_token.toString(),
          'password': passwordController.text,
        };
        print('----perams--->  $perams}');
        final response = await http.post(
          Uri.parse(url),
          body: perams,
        );


        print(response.body);
        final data = json.decode(response.body);

        if (data['success'] == true) {
          storage.write('api_token_login', data['data']['api_token']);
          storage.write('restoreid', data['data']['restoreid']);
          storage.write('email', data['data']['email']);
          storage.write('name', data['data']['name']);
          if(data['data']['email_verified']=='1'){
            print('----------------------------------email_verified is Done--------------------> ${data['data']['email_verified']}');
            String email = data['data']['email'];
            storage.write('email_verified', data['data']['email_verified']);
            var prefs = await SharedPreferences.getInstance();
            prefs.setString('email', data['data']['email']);
            email_verify = data['data']['email_verified'];
            print(':-> $email');
            getKitchen();

          }else{

            print('----------------------------------email_verified is null-------------------->');
            setState(() {
              loading = false;
            });
            Navigator.of(context).pushReplacement(
              NoBlinkPageRoute(
                builder: (context) =>  emails_screen(email:  data['data']['email'],type: 'Registration',come_from:'login'),
              ),
            );
          }
          storage.write('kitchenDetails', data['data']['kitchen_status']);
        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
          setState(() {
            loading = false;
          });
          Wid_Con.toastmsgr(context: context,msg:errorMessage);

        }
      }
    }
  }
  void getKitchen() async {
    const url = '${Url}details';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );
    final data = json.decode(response.body);

    if (data['success'] == true) {
      if(data['data']['active']==false){
        storage.write('isActive', false);
      }else{
        storage.write('isActive', true);
      }
      // iskitchenDetail = false;
      setState(() {
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) =>  bottom_screen(pageindex:0),
          ),
        );
      });
      storage.write('IsKitchen', false);
    } else {
      setState(() {
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) =>  bottom_screen(pageindex: 4),
          ),
        );
      });
      storage.write('IsKitchen', true);
      String errorMessage = data['message'];
      print('error :-> $errorMessage');
    }
  }


  // 199278360602810
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token){
      setState(() {
        Device_token = token.toString();
        print("---token is--- $Device_token");
      });
    });

    // getKitchen();
    // if(widget.isnotvalid==0){
    //   emailController.text==widget.validEmail.toString();
    // }
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
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child:
                        Image.asset('assets/images/come_eat.png', height: 110),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: emailController,
                        cursorColor: grey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: Usernamevalidation == true
                              ? 'Enter your Email'
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.016),
                          hintText: 'Email ID',
                          hintStyle: TextStyle(
                              color: black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: passwordController,
                        obscureText: isVisible,
                        cursorColor: grey,
                        decoration: InputDecoration(
                          errorText: Passvalidation == true
                              ? 'Enter your Password'
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.016),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors
                                  .transparent, // This makes the checkbox border transparent
                            ),
                            child: Checkbox(
                              fillColor: MaterialStateProperty.all(white),
                              value: isChecked,
                              checkColor: black,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                                fontSize: 12,
                                color: white,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Poppins'),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  NoBlinkPageRoute(
                                      builder: (context) =>
                                          const email_screen()));
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wid_Con.button(
                                child: Center(
                                  child: loading == false
                                      ? Text(
                                          'Sign In',
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins'),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: CircularProgressIndicator(
                                            color: white,
                                          ),
                                        ),
                                ),
                                titelcolor: white,
                                onPressed: () {
                                  setState(() {
                                    // if('0' == '1'){
                                    FocusScope.of(context).unfocus();
                                      handleLogin();
                                    // }else{
                                    //   Navigator.pushReplacement(
                                    //       context,
                                    //       NoBlinkPageRoute(
                                    //           builder: (context) =>
                                    //               emails_screen(email: emailController.text,type: 'Registration',)));
                                    // }

                                  });
                                },
                                ButtonRadius: 5,
                                fontSize: 18,
                                height: 50,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Wid_Con.button(
                                ButtonName: 'Register',
                                titelcolor: white,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      NoBlinkPageRoute(
                                          builder: (context) =>
                                              const register_screen()));
                                },
                                ButtonRadius: 5,
                                fontSize: 18,
                                height: 50,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),const SizedBox(
                        height: 25,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
