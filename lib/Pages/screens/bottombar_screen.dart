import 'dart:async';
import 'dart:convert';
import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../Constants/App_Colors.dart';
import '../../Constants/Custum_bottombar/Bottombar.dart';
import '../test.dart';
import 'Login_Screen/Login_Screen.dart';
import 'Food_Screen/addfood_screen.dart';
import 'Dashboard_screen/dashboard_screen.dart';
import 'Food_Screen/food_screen.dart';
import 'Login_Screen/Start_Screen.dart';
import 'Notification_Screen/notification_screen.dart';
import 'Service/notificationservice/local_notification_service.dart';

// bool iskitchenDetail = false;

class bottom_screen extends StatefulWidget {
  const bottom_screen({Key? key, this.pageindex, this.isKitchen}) : super(key: key);
  final pageindex;
  final isKitchen;

  @override
  State<bottom_screen> createState() => _bottom_screenState();
}

class _bottom_screenState extends State<bottom_screen> {
  int pageIndex = 0;
  bool? isActive;

  List pages = [
    const dashboard_screen(),
    const food_screen(),
    const addfood_screen(),
    const notification_screen(),
    const profile_screen(),
  ];
  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // late String currentToken;
  // String userId = FirebaseAuth.instance.currentUser!.uid;



  @override
  void initState() {
    // TODO: implement i

    print('----------------------bottom-------------------------------');
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          LocalNotificationService.createanddisplaynotification(message);
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen((message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // _messaging.getToken().then((value) {
    //   print(value);
    //   if (mounted)
    //     setState(() {
    //       currentToken = value!;
    //     });
    //   FirebaseFirestore.instance
    //       .collection('pushtokens')
    //       .doc(userId)
    //       .set({'token': value!, 'createdAt': DateTime.now()});
    // });
    if (widget.pageindex != null) {
      pageIndex = widget.pageindex;
      print('-----------index------------------> $pageIndex');
    }
    Timer.periodic(Duration(seconds: 5), (timer) {

      if(storage.read('api_token_login')!=null){
        getKitchen();
      }
    });
  }


  void getKitchen() async {
    const url = '${Url}details';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );
   // print(url);
   //  print(response.body);
    final data = json.decode(response.body);

    if(response.statusCode==200||response.statusCode==201) {
      if (data['success'] == true) {


       //  print('------- 1 ${data['data']}');
        if(data['data']['active']==false){

          if (mounted)setState(() {
            storage.write('isActive', false);
            isActive = false;
          });

        }else{
          if (mounted) setState(() {
            storage.write('isActive', true);
            isActive = true;
          });

        }
        // iskitchenDetail = false;

        storage.write('IsKitchen', false);
      } else {
        if (mounted) setState(() {
          storage.write('IsKitchen', true);
        });
        String errorMessage = data['message'];
        print('error :-> $errorMessage');
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

// --- Button Widget --- //


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        bottomNavigationBar: const Bottombar(),

        // Container(
        //   height: MediaQuery.of(context).size.height * 0.1,
        //   color: const Color(0XFF000000).withOpacity(0.2),
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Theme(
        //           data: ThemeData(
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //           ),
        //           child: InkWell(
        //             onTap: () {
        //               setState(() {
        //                 pageIndex = 0;
        //               });
        //             },
        //             child: SizedBox(
        //               width: MediaQuery.of(context).size.width * 0.19,
        //               child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Image.asset('assets/images/dashboard.png',
        //                         height:20.sp,
        //                         color: pageIndex == 0 ? orange : grey),
        //                     const SizedBox(
        //                       height: 8,
        //                     ),
        //                     Text(
        //                       'Dashboard',
        //                       style: TextStyle(
        //                           fontFamily: "Poppins",
        //                           color:
        //                           pageIndex == 0 ? orange : greyfont,
        //                           fontSize: 9.5.sp,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ]),
        //             ),
        //           ),
        //         ),
        //         Theme(
        //           data: ThemeData(
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //           ),
        //           child: InkWell(
        //             onTap: () {
        //               setState(() {
        //                 pageIndex = 1;
        //               });
        //             },
        //             child: SizedBox(
        //               width: MediaQuery.of(context).size.width * 0.19,
        //               child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Image.asset('assets/images/food.png',
        //                         height:20.sp,
        //                         color: pageIndex == 1 ? orange : grey),
        //                     const SizedBox(
        //                       height: 8,
        //                     ),
        //                     Text(
        //                       "Foods",
        //                       style: TextStyle(
        //                           fontFamily: "Poppins",
        //                           color:
        //                           pageIndex == 1 ? orange : greyfont,
        //                           fontSize: 9.5.sp,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ]),
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(bottom: 10,top: 10),
        //           child: SizedBox(
        //             width: MediaQuery.of(context).size.width * 0.2,
        //             child: Theme(
        //               data: ThemeData(
        //                 splashColor: Colors.transparent,
        //                 highlightColor: Colors.transparent,
        //               ),
        //               child: StatefulBuilder(
        //                 builder: (context, setState) =>  InkWell(
        //                   onTap: ()async {
        //                     const url = '${Url}details';
        //                     final response = await http.get(
        //                       Uri.parse(url),
        //                       headers: {
        //                         'Authorization': 'Bearer ${storage.read('api_token_login')}',
        //                       },
        //                     );
        //                     final data = json.decode(response.body);
        //
        //                     if(response.statusCode==200||response.statusCode==201) {
        //                       if (data['success'] == true) {
        //                         if(data['data']['active']==false){
        //                           Fluttertoast.showToast(
        //                             msg: 'Your account is under verification process.',
        //                             fontSize: 16,
        //                             backgroundColor: black,
        //                             gravity: ToastGravity.TOP,
        //                             textColor: white,
        //                           );
        //                           setState(() {
        //                             isActive = false;
        //                           });
        //                         }else{
        //                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const bottom_screen(pageindex: 2)));
        //                           setState(() {
        //                             pageIndex = 2;
        //                             isActive = true;
        //                           });
        //                         }
        //                         storage.write('IsKitchen', false);
        //                         setState(() {
        //                         });
        //
        //                         // iskitchenDetail = false;
        //
        //
        //                       } else {
        //                         Fluttertoast.showToast(
        //                           msg: 'Your account is under verification process.',
        //                           fontSize: 16,
        //                           backgroundColor: black,
        //                           gravity: ToastGravity.TOP,
        //                           textColor: white,
        //                         );
        //                         storage.write('IsKitchen', true);
        //                         String errorMessage = data['message'];
        //                         print('error :-> $errorMessage');
        //                       }
        //                     }else if(response.statusCode==401||response.statusCode==400){
        //                       Navigator.of(context).pushReplacement(
        //                         MaterialPageRoute(
        //                           builder: (context) => const start_screen(),
        //                         ),
        //                       );
        //                       storage.remove('email_verified');
        //                       storage.remove('api_token_login');
        //                     }
        //
        //                   },
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(1.0),
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(15),
        //                         gradient:  LinearGradient(
        //                           begin: Alignment.topRight,
        //                           end: Alignment(0.5, 1),
        //                           colors:storage.read('isActive')==true ? [
        //                             Color(0xFFC73C1B),
        //                             Color(0xFFE49630),
        //                           ]:[grey,grey],
        //                         ),
        //                       ),
        //                       child: Center(
        //                         child:
        //                         Icon(Icons.add, color: white, size: 25),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         Theme(
        //           data: ThemeData(
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //           ),
        //           child: InkWell(
        //             onTap: () {
        //               setState(() {
        //                 pageIndex = 3;
        //               });
        //             },
        //             child: SizedBox(
        //               width: MediaQuery.of(context).size.width * 0.19,
        //               child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Image.asset('assets/images/noti.png',
        //                         height:20.sp,
        //                         color: pageIndex == 3 ? orange : grey),
        //                     const SizedBox(
        //                       height: 8,
        //                     ),
        //                     Text(
        //                       "Notification",
        //                       style: TextStyle(
        //                           fontFamily: "Poppins",
        //                           color:
        //                           pageIndex == 3 ? orange : greyfont,
        //                           fontSize: 9.5.sp,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ]),
        //             ),
        //           ),
        //         ),
        //         Theme(
        //           data: ThemeData(
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //           ),
        //           child: InkWell(
        //             onTap: () {
        //               setState(() {
        //                 pageIndex = 4;
        //               });
        //             },
        //             child: SizedBox(
        //               width: MediaQuery.of(context).size.width * 0.19,
        //               child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Image.asset('assets/images/prifile.png',
        //                         height:20.sp,
        //                         color: pageIndex == 4 ? orange : grey),
        //                     const SizedBox(
        //                       height: 8,
        //                     ),
        //                     Text(
        //                       "My Profile",
        //                       style: TextStyle(
        //                           fontFamily: "Poppins",
        //                           color:
        //                           pageIndex == 4 ? orange : greyfont,
        //                           fontSize: 9.5.sp,
        //                           fontWeight: FontWeight.w500),
        //                     )
        //                   ]),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: pages[pageIndex],
      ),
    );
  }
}
