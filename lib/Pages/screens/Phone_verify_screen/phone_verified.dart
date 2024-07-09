// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Constants/App_Colors.dart';
// import '../screens/bottombar_screen.dart';
//
//
// class phone_verified extends StatefulWidget {
//   const phone_verified({Key? key}) : super(key: key);
//
//   @override
//   State<phone_verified> createState() => _phone_verifiedState();
// }
//
// class _phone_verifiedState extends State<phone_verified> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer(const Duration(milliseconds: 1000),
//             () =>
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const bottom_screen()))
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Container(
//                 height: 90,
//                 width: 90,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFC73C1B),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Container(
//                   margin: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE18D2E),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Icon(Icons.done,size: 55),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20,),
//             Text('Your Mobile No Verified',style: TextStyle(fontFamily: 'Poppins',fontSize: 25,color: blue,fontWeight: FontWeight.w600)),
//             SizedBox(height: 15,),
//             Text(
//               'You will be redirected to the main page'.tr,
//               style: TextStyle(
//                   fontSize: 13, color: blue, fontWeight: FontWeight.w400,fontFamily: 'Poppins'),
//             ),
//             Text(
//               'in a few moments'.tr,
//               style: TextStyle(
//                   fontSize: 13, color: blue, fontWeight: FontWeight.w400,fontFamily: 'Poppins'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
