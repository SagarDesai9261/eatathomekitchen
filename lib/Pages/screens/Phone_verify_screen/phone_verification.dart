// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:comeeathome/Pages/Email/email_verified.dart';
// import 'package:comeeathome/Pages/Phone/phone_verified.dart';
// import 'package:comeeathome/Constants/Widget.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:otp_text_field/otp_text_field.dart';
// import 'package:otp_text_field/style.dart';
// import '../../Constants/App_Colors.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
//
// class phone_screen extends StatefulWidget {
//   const phone_screen({Key? key}) : super(key: key);
//
//   @override
//   State<phone_screen> createState() => _phone_screenState();
// }
//
// class _phone_screenState extends State<phone_screen> {
//
//   bool isVisible = false;
//
//   final pinController = TextEditingController();
//   final focusNode = FocusNode();
//
//   @override
//   void dispose() {
//     pinController.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//   }
//
//
//   void verify() async {
//
//     print('---->step 1');
//     try {
//       print('---->step 2');
//
//       const url = 'https://comeeathome.com/app/api/kitchen/verify-code';
//       final response = await http.post(
//         Uri.parse(url),
//         body: {
//           'api_token': storage.read('api_token_login'),
//           'code': storage.read('pin'),
//         },
//       );
//       print('---->step 3');
//       if (response.statusCode == 200) {
//         print('---->step 4');
//         final  data = json.decode(response.body);
//         print('---->step 5');
//         print('$data');
//         if (data['success'] == true) {
//           // ignore: use_build_context_synchronously
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const phone_verified()));
//
//           print('---->step 6');
//
//
//         } else {
//           String errorMessage = data['message'];
//           print('error :-> $errorMessage');
//           // Handle login failure
//         }
//       }
//
//
//     } catch (e) {
//       // Handle other error scenarios like network issues or unexpected responses
//       log('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var focusedBorderColor = grey;
//     var fillColor = white;
//     var borderColor = grey;
//
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: TextStyle(
//         fontSize: 18,
//         color: black,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         border: Border.all(color: borderColor),
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: Wid_Con.App_Bar(
//           leading: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: GestureDetector(
//               onTap: (){
//                 Navigator.pop(context);
//               },
//               child: Image.asset(
//                 'assets/images/arrow.png',
//               ),
//             ),
//           ),
//           titel: 'MOBILE VERIFICATION',fontweight: FontWeight.w600
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 18,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.1,
//                 ),
//                 Text(
//                   'We Sent You a Code to Verify'.tr,
//                   style: TextStyle(
//                       fontSize: 14,
//                       color: black,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Poppins'),
//                 ),
//                 Text(
//                   'Your Mobile No'.tr,
//                   style: TextStyle(
//                       fontSize: 14,
//                       color: black,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Poppins'),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.06,
//                 ),
//                 Text(
//                   'Enter your OTP code here'.tr,
//                   style: TextStyle(
//                       fontSize: 13,
//                       color: grey,
//                       fontWeight: FontWeight.w200,
//                       fontFamily: 'Poppins'),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.04,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Pinput(
//                     controller: pinController,
//                     focusNode: focusNode,
//                     androidSmsAutofillMethod:
//                     AndroidSmsAutofillMethod.smsUserConsentApi,
//                     listenForMultipleSmsOnAndroid: true,
//                     defaultPinTheme: defaultPinTheme,
//                     separatorBuilder: (index) => const SizedBox(width: 8),
//                     validator: (value) {
//                       return value == '1111' ? null : 'Pin is incorrect';
//                     },
//                     // onClipboardFound: (value) {
//                     //   debugPrint('onClipboardFound: $value');
//                     //   pinController.setText(value);
//                     // },
//                     hapticFeedbackType: HapticFeedbackType.lightImpact,
//                     onCompleted: (pin) {
//                       debugPrint('onCompleted: $pin');
//                       setState(() {
//                         isVisible = !isVisible;
//                       });
//                     },
//                     onChanged: (value) {
//                       debugPrint('onChanged: $value');
//                     },
//                     cursor: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Container(
//                             //margin: EdgeInsets.symmetric(vertical: 15),
//                             width: 1,
//                             height: 20,
//                             color: focusedBorderColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     focusedPinTheme: defaultPinTheme.copyWith(
//                       decoration: defaultPinTheme.decoration!.copyWith(
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(color: focusedBorderColor),
//                       ),
//                     ),
//                     submittedPinTheme: defaultPinTheme.copyWith(
//                       decoration: defaultPinTheme.decoration!.copyWith(
//                         color: grey200,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(color: trans),
//                       ),
//                     ),
//                     errorPinTheme: defaultPinTheme.copyBorderWith(
//                       border: Border.all(color: Colors.redAccent),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.08,
//                 ),
//                 Text(
//                   'I didn’t receive a code!'.tr,
//                   style: TextStyle(
//                       fontSize: 13,
//                       color: grey,
//                       fontWeight: FontWeight.w200,
//                       fontFamily: 'Poppins'),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Resend code'.tr,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'Poppins'),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.1,
//                 ),
//                 isVisible == true
//                     ? Wid_Con.button(
//                   ButtonName: 'Verify Now',
//                   onPressed: () {
//                     verify();
//
//                   },
//                   ButtonColor: bluefont,
//                   height: 50,
//                   width: MediaQuery.of(context).size.width / 1.5,
//                   ButtonRadius: 10,
//                   titelcolor: white,
//                 )
//                     : const SizedBox(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
