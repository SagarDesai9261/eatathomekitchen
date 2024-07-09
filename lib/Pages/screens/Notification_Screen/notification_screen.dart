import 'dart:convert';
import 'dart:developer';

import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:comeeathome/Constants/Widget.dart';
import 'package:comeeathome/Pages/screens/Dashboard_screen/banner_image.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Payout_Screen/Addcard_screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import 'package:http/http.dart' as http;

import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../Service/Privacy_policy.dart';
import '../bottombar_screen.dart';
import '../Dashboard_screen/dashboard_screen.dart';

class notification_screen extends StatefulWidget {
  const notification_screen({Key? key}) : super(key: key);

  @override
  State<notification_screen> createState() => _notification_screenState();
}

class _notification_screenState extends State<notification_screen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void logout() async {
    print('---->step 1');
    try {
      print('---->step 2');

      const url = '${Url}settings';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );
      print(response.body);
      print('---->step 3');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('---->step 4');
        final data = json.decode(response.body);
        print('---->step 5');

        if (data['success'] == true) {
          setState(() {

          });

          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            NoBlinkPageRoute(
              builder: (context) => const login_screen(),
            ),
          );
          storage.remove('email_verified');
          storage.remove('api_token_login');
        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
        }
      }else if(response.statusCode==401||response.statusCode==400){
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) => const login_screen(),
          ),
        );
        storage.remove('email_verified');
        storage.remove('api_token_login');
      }
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }

  List notification = [];
  bool isLoading = false;
  DateTime? date;
  String dateformat = '';

  void getNotification() async {
    print('---->step 1');
    try {
      print('---->step 2');

      const url = '${Url}notifications';
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );

      print('---->step 3');

      final data = json.decode(response.body);
      print('---->step 4');

      if(response.statusCode==200||response.statusCode==201) {
        if (data['success'] == true) {
          setState(() {
            notification.add(data['data']);
          });
          log('$notification');

          // date = DateTime.parse(notification[0][index]['user_name']);
          // dateformat = DateFormat('MMM d, yyyy h:mm').format(date!);
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
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

    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) => const bottom_screen()))) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFF5F5F5),
          key: scaffoldKey,
          appBar: Wid_Con.App_Bar(
            leading: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  'assets/images/list.png',
                ),
              ),
            ),
            titel: 'NOTIFICATIONS',
            fontweight: FontWeight.w600,
            actions: [
              SizedBox(width: 6.w,)
              // Padding(
              //   padding: const EdgeInsets.only(right: 8),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const profile_screen()));
              //     },
              //     child: Icon(
              //       Icons.account_circle_outlined,
              //       color: grey,
              //     ),
              //   ),
              // ),
            ],
          ),
          drawer: Wid_Con.drawer(
              width: MediaQuery.of(context).size.width * 0.75,
              onPressedfav: () {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
              },
              onpressBannerimage: () {
                Navigator.pop(context);
                Navigator.push(context,
                    NoBlinkPageRoute(builder: (context) =>  ImageSelectionScreen()));
              },
              onPresprivacypolicy: () {
                Navigator.pop(context);
                Navigator.push(context,
                    NoBlinkPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
              },
              onPressedorder: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    NoBlinkPageRoute(
                        builder: (context) => const Orders_Screen(orderdrawer: true,)));
              },
              onPressedreview: () {
                Navigator.pop(context);
                Navigator.push(context,
                    NoBlinkPageRoute(builder: (context) => const ReviewSreen()));
              },
              onPressedpay: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    NoBlinkPageRoute(
                        builder: (context) => const payoutDetails_screen()));
              },
              onPressedlan: () {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
              },
              onPressedad: () {
                Navigator.pop(context);
                showDialog(
                    context: context, builder: (context) =>add_discount());
              },
              onPressedlogout: () {
                logout();
              }),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoading == true
                    ? Center(child: CircularProgressIndicator(color: blue,))/*Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.h),
                          child: Image.asset(
                            'assets/images/notification.png',
                          ),
                        ),
                      )*/
                    : notification.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: notification[0].length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = notification[0][index];
                                final DateTime date =
                                    DateTime.parse(item['time']);
                                final String dateformat =
                                    DateFormat('MMM d, yyyy h:mm').format(date);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(55),
                                              image:  DecorationImage(
                                                  image: NetworkImage(
                                                      notification[0][index]
                                                      ['image']),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    text: notification[0][index]
                                                        ['user_name'],
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: bluefont,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '  ${notification[0][index]['message']}',
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: greyfont,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  dateformat,
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: greyfont),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Container(
                                              decoration: BoxDecoration(

                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 5),
                                                child: Text(
                                                    notification[0][index]
                                                        ['order_type'],
                                                    style: TextStyle(
                                                        fontSize: 8.sp,
                                                        color: red,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 0.5,
                                        width: double.infinity,
                                        color: grey300,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.h),
                              child: Image.asset(
                                'assets/images/notification.png',
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
