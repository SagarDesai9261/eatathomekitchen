import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/App_Colors.dart';
import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Payout_Screen/payoutDetails_screen.dart';
import '../Review_Screen/Review_screen.dart';
import 'package:http/http.dart' as http;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatAtHome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PrivacyPolicyScreen(),
    );
  }
}

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void logout() async {
  //  loading = true;
    try {
      const url = 'https://eatathome.in/app/api/kitchen/settings';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );
      print('${response.body}');
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          setState(() {});
        //  loading = false;
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
          print('error ---> $errorMessage');
        }
      } else if (response.statusCode == 401 || response.statusCode == 400) {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  Wid_Con.App_Bar(
          leading: Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                scaffoldKey.currentState?.openDrawer();
                print("calling");
              },
              child: Image.asset(
                'assets/images/list.png',
              ),
            ),
          ),
            titel: "Privacy Policy",
          fontweight: FontWeight.w600,
          actions: [

            // IconButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const profile_screen()));
            //   },
            //   icon: Icon(
            //     Icons.account_circle_outlined,
            //     color: grey,
            //   ),
            // )
          ]),
      drawer: Wid_Con.drawer(
          width: MediaQuery.of(context).size.width * 0.75,
          onPressedfav: () {
            Navigator.pop(context);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const Orders_Screen()));
          },
          onPressedorder: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                NoBlinkPageRoute(
                    builder: (context) => const Orders_Screen(
                      orderdrawer: true,
                    )));
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
          },
          onPressedad: () {
            Navigator.pop(context);
            Navigator.push(context,
                NoBlinkPageRoute(builder: (context) => const add_discount()));
          },
          onpressBannerimage: () {
            Navigator.pop(context);
            Navigator.push(context,
                NoBlinkPageRoute(builder: (context) =>  ImageSelectionScreen()));
          },
          onPressedlogout: () {
            logout();
          }),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''EatAtHome ("we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our website and mobile application (collectively, the "Services"). By accessing or using our Services, you agree to the terms of this Privacy Policy.

We collect personal information such as your name, email address, phone number, and payment details when you register for an account, place an order, or contact us. Additionally, we collect live location data to provide location-based services, including finding nearby cooks, tracking your orders, and ensuring accurate delivery. You can enable or disable location services through your mobile device settings.

We use your information to operate and maintain our Services, process and manage orders, communicate with you, and enhance your user experience. We may share your information with third-party service providers, cooks, and delivery partners as necessary to fulfill your orders and provide customer support. We take reasonable measures to protect your personal information, but please note that no security measures are completely infallible.''',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
