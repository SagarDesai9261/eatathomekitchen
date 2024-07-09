import 'dart:convert';
import 'dart:developer';

import 'package:comeeathome/Pages/screens/Login_Screen/Login_Screen.dart';
import 'package:comeeathome/Pages/screens/Verification_Screen/email_verified.dart';
import 'package:comeeathome/Constants/Widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../../../Constants/App_Colors.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import '../../test.dart';
import '../Login_Screen/Start_Screen.dart';

class emails_screen extends StatefulWidget {
  const emails_screen({Key? key, this.email, this.type,this.come_from}) : super(key: key);
  final email;
  final type;
  final come_from;

  @override
  State<emails_screen> createState() => _emails_screenState();
}

class _emails_screenState extends State<emails_screen> {

  bool isVisible = false;
bool? iswait;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.come_from=='login'){
      handleverify(UserMail: widget.email);
    }
   //
  }

  void handleverify({String? UserMail}) async {
    const url = '${Url}resend-verification-code';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': UserMail,
      },
    );

    print(response.body);
    final data = json.decode(response.body);

    if(response.statusCode==200||response.statusCode==201) {
      if (data['success'] == true) {
        setState(() {
          iswait = false;
        });
      } else {
        String errorMessage = data['message'];
        print('error :-> $errorMessage');
        setState(() {

        });

        Wid_Con.toastmsgr(context: context,msg:errorMessage);
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

  }

  void verify() async {
    // try {


     var body = {
        'email' : widget.email,
        'code': storage.read('pin'),
        'type' : widget.type,
      };
    print('---->step 2 $body');
      const url = '${Url}verify-code';
      final response = await http.post(
        Uri.parse(url),
        body: body
      );
        print("hello "+response.body);
        final data = json.decode(response.body);
        print(data["success"]);

        if(data["success"] == false){
          Wid_Con.toastmsgr(context: context,msg:"Pin not matched.");
        }else {
          if (response.statusCode == 200 || response.statusCode == 201) {
            if (data['success'] == true) {
              storage.write('email_verified', data['data']['email_verified']);
              // ignore: use_build_context_synchronously
              Navigator.push(context,
                  NoBlinkPageRoute(
                      builder: (context) => const email_verified()));

            } else {
              String errorMessage = data['message'];
              print('error :-> $errorMessage');
              Wid_Con.toastmsgr(context: context,msg:errorMessage);
              // Handle login failure
            }
          } else if (response.statusCode == 401 || response.statusCode == 400) {
            Navigator.of(context).pushReplacement(
              NoBlinkPageRoute(
                builder: (context) => const start_screen(),
              ),
            );
            storage.remove('email_verified');
            storage.remove('api_token_login');
          }
        }
    // } catch (e) {
    //   // Handle other error scenarios like network issues or unexpected responses
    //   log('Errorr: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    var focusedBorderColor = grey;
    var fillColor = white;
    var borderColor = grey;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 18,
        color: black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if(widget.come_from=='login'){
            Navigator.pushReplacement(
                context,
                NoBlinkPageRoute(
                    builder: (context) =>
                        login_screen()));
          }
          else{
            Navigator.pop(context);
          }
          return true;
        },
        child: Scaffold(
          appBar: Wid_Con.App_Bar(
            padding: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 5,top: 15,bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    if(widget.come_from=='login'){
                      Navigator.pushReplacement(
                          context,
                          NoBlinkPageRoute(
                              builder: (context) =>
                              login_screen()));
                    }
                    else{
                      Navigator.pop(context);
                    }

                  },
                  child: Image.asset(
                    'assets/images/arrow.png',
                  ),
                ),
              ),
              titel: 'EMAIL VERIFICATION',
              fontweight: FontWeight.w600),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    'We Sent You a Code to Verify'.tr,
                    style: TextStyle(
                        fontSize: 14,
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  Text(
                    'Your Email Id'.tr,
                    style: TextStyle(
                        fontSize: 14,
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Text(
                    'Enter your OTP code here'.tr,
                    style: TextStyle(
                        fontSize: 13,
                        color: grey,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Pinput(
                      controller: pinController,
                      focusNode: focusNode,
                //      androidSmsAutofillMethod:
                    //      AndroidSmsAutofillMethod.smsUserConsentApi,
                  //    listenForMultipleSmsOnAndroid: true,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      // validator: (value) {
                      //   return value == '1111' ? null : 'Pin is incorrect';
                      // },
                      onClipboardFound: (value) {
                        debugPrint('onClipboardFound: $value');
                        pinController.setText(value);
                      },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                        storage.write('pin', pin);
                        setState(() {
                          isVisible = true;
                        });
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              //margin: EdgeInsets.symmetric(vertical: 15),
                              width: 1,
                              height: 20,
                              color: focusedBorderColor,
                            ),
                          ),
                        ],
                      ),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: grey200,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: trans),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Text(
                    'I didn’t receive a code!'.tr,
                    style: TextStyle(
                        fontSize: 13,
                        color: grey,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        iswait = true;
                      });
                      handleverify(UserMail: widget.email);
                      Wid_Con.toastmsgr(context: context,msg:'Please wait...');
                    },
                    child:iswait!=true? Text(
                      'Resend code'.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins'),
                    ):CircularProgressIndicator(color: bluefont),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  isVisible == true
                      ? Wid_Con.button(
                          ButtonName: 'Verify Now',
                          onPressed: () {
                            verify();
                          },
                          ButtonColor: bluefont,
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.5,
                          ButtonRadius: 10,
                          titelcolor: white,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
