import 'dart:convert';
import 'dart:developer';

import 'package:comeeathome/Pages/screens/Verification_Screen/email_verification.dart';
import 'package:comeeathome/Pages/screens/Phone_verify_screen/phone_verification.dart';
import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Login_Screen/Login_Screen.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants/App_Colors.dart';
import 'package:http/http.dart' as http;
import '../../test.dart';
import 'Forgot_Pass_Screen.dart';

class register_screen extends StatefulWidget {
  const register_screen({Key? key}) : super(key: key);

  @override
  State<register_screen> createState() => _register_screenState();
}

class _register_screenState extends State<register_screen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String phonenumber = "";
  bool isVisible = true;
  bool isChecked = false;

  double getFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define font size based on screen width
    if (screenWidth <= 320) {
      return 12.0; // Small screens
    } else if (screenWidth <= 480) {
      return 13.0; // Medium screens
    } else {
      return 14.0; // Larger screens
    }
  }

  bool? Usernamevalidation;
  bool? Passvalidation;
  bool? Namevalidation;
  bool? Phonevalidation;
  bool loading = false;
  String Device_token = "";


  void register() async {
    String name = nameController.text;
    String user = emailController.text;
    String pass = passwordController.text;
    String phone = phonenumber;
    print(phone);
      if (name.isEmpty) {
        Wid_Con.toastmsgr(context: context,msg:"Name required");

      } else {

        if (user.isEmpty || !RegExp(
            r"^[a-zA-Z0-9.+]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(user)) {
          Wid_Con.toastmsgr(context: context,msg:"Invalid Email");
        } else {

          if (phone.isEmpty) {
            Wid_Con.toastmsgr(context: context,msg:"Phone number required");

          } else {
            setState(() {});
            Phonevalidation = false;
            if (pass.isEmpty) {
              Wid_Con.toastmsgr(context: context,msg:"Password required");
            } else {
              setState(() {});
              Passvalidation = false;
              loading = true;
              const url = '${Url}register';

              final perams = {
                'name': nameController.text,
                'email': emailController.text,
                'device_token': Device_token.toString(),
                'phone':phonenumber,
                'password': passwordController.text,
              };
              print('-------perams-----> $perams');
              final response = await http.post(
                Uri.parse(url),
                body: perams,
              );

                final data = json.decode(response.body);
                print('---->step 7 --> $data');

                if (data['success'] == true) {

                  String api_token = data['data']['api_token'];

                  storage.write('api_token_login', data['data']['api_token']);
                  storage.write('api_token_verified', data['data']['api_token']);

                  print(':-> $api_token');
                  setState(() {
                    loading = false;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      NoBlinkPageRoute(
                          builder: (context) =>
                           emails_screen(email: emailController.text,type: 'Registration',)));
                } else {
                  setState(() {
                    loading = false;
                  });
                  Wid_Con.toastmsgr(context: context,msg:data['message'][0].toString());
                  String errorMessage = data['message'];
                  print('error :-> $errorMessage');
                  // Handle login failure
                }

            }
          }
        }
      }

  }


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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Image.asset('assets/images/come_eat.png',
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.5),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Create Account'.tr,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              color: white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Fill Your Information Below Or Register'.tr,
                          style: TextStyle(
                              fontSize: fontSize,
                              color: white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        Text(
                          'With Your Social Account.'.tr,
                          style: TextStyle(
                              fontSize: fontSize,
                              color: white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                cursorColor: grey,
                                decoration: InputDecoration(
                                  errorText: Namevalidation == true
                                      ? 'Enter your Name'
                                      : null,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: white, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: white, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  fillColor: white,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.016),
                                  filled: true,
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                      color: black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              const SizedBox(
                                height: 28,
                              ),
                              TextFormField(
                                controller: emailController,
                                cursorColor: grey,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  errorText: Usernamevalidation == true
                                      ? 'Enter your Email'
                                      : null,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: white, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: white, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  fillColor: white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.016),
                                  hintText: 'Email ID',
                                  hintStyle: TextStyle(
                                    color: black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 28,
                              ),
                          Container(
                           // color: Colors.grey,
                          //  margin: EdgeInsets.symmetric(vertical: 4),
                            child: TextFormField(
                              //controller:phoneController ,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                errorText: Phonevalidation == true
                                    ? 'Enter your Phone'
                                    : null,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                  color: black,
                                  fontSize:
                                  16
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.white, // Set to your desired border color
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.white, // Set to your desired border color
                                    width: 1,
                                  ),
                                ),
                              ),
                              onChanged: (phone) {
                                setState(() {
                                  phonenumber = phone;
                                });
                              },
                              style: TextStyle(
                                  color: black,
                                  fontSize:
                                  16
                              ),
                            ),
                          ),
                              const SizedBox(
                                height: 28,
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
                                      borderSide:
                                          BorderSide(color: white, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: white, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  fillColor: white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.016),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: !isVisible
                                          ? Image.asset(
                                              'assets/images/visible_off.png',
                                              height: 10,
                                            )
                                          : Image.asset(
                                              'assets/images/visible_on.png',
                                              height: 10),
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              Row(
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors
                                          .transparent, // This makes the checkbox border transparent
                                    ),
                                    child: Checkbox(
                                      fillColor:
                                          MaterialStateProperty.all(white),
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

                                ],
                              ),
                            ],
                          ),
                        ),
                        Wid_Con.button(
                            // ButtonName: 'Sign Up',
                          child: Center( child:loading==false? Text('Sign Up',style: TextStyle(
                              color: white,
                              fontSize:  18,
                              fontWeight:  FontWeight.w400,
                              fontFamily: 'Poppins'),):Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircularProgressIndicator(color: white,),
                              )),
                            titelcolor: white,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                                register();
                            },
                            ButtonRadius: 5,
                            height: 45,
                            width: 150,
                            fontSize: 18),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                      /*  Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.3,
                                color: white,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Or Sign up with',
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
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
                              child: Image.asset('assets/images/google.png',
                                  height: 30),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: white,
                                  fontFamily: 'Poppins'),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: red,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
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
