import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:comeeathome/Constants/Dialog/cuisineDialog.dart';
import 'package:comeeathome/Pages/screens/Login_Screen/Start_Screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Payout_Screen/Addcard_screen.dart';
import '../Orders_Screen/Order_Management_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Service/Privacy_policy.dart';
import 'banner_image.dart';

class dashboard_screen extends StatefulWidget {
  const dashboard_screen({Key? key}) : super(key: key);

  @override
  State<dashboard_screen> createState() => _dashboard_screenState();
}

class _dashboard_screenState extends State<dashboard_screen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool? loading;
  final APPID = "ccd5820a-d45f-4698-8c06-81be62a9b153";
  final APPKEY = "32d74b1d-29ff-40ed-9355-2b97c0b20670";
  final DOMAIN = "msdk.in.freshchat.com";
  FreshchatUser? user;
  String firstName = "",
      lastName = "",
      email = "",
      phoneCountryCode = "",
      phoneNumber = "",
      key = "",
      value = "",
      conversationTag = "",
      message = "",
      eventName = "",
      topicName = "",
      topicTags = "",
      jwtToken = "",
      freshchatUserId = "",
      userName = "",
      externalId = "",
      restoreId = "",
      jwtTokenStatus = "",
      obtainedRestoreId = "",
      sdkVersion = "",
      parallelConversationReferenceID1 = "",
      parallelConversationTopicName1 = "",
      parallelConversationReferenceID2 = "",
      parallelConversationTopicName2 = "";
  StreamSubscription? restoreStreamSubscription,
      fchatEventStreamSubscription,
      unreadCountSubscription,
      linkOpenerSubscription,
      notificationClickSubscription,
      userInteractionSubscription;
  Map eventProperties = {}, unreadCountStatus = {};
  void registerFcmToken() async {
    if (Platform.isAndroid) {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token is generated $token");
      Freshchat.setPushRegistrationToken(token!);
    }
  }
  void getUser() async {
    user = await Freshchat.getUser;
  }

  Future<String> getTokenStatus() async {
    JwtTokenStatus jwtStatus = await Freshchat.getUserIdTokenStatus;
    jwtTokenStatus = jwtStatus.toString();
    jwtTokenStatus = jwtTokenStatus.split('.').last;
    return jwtTokenStatus;
  }

  //NOTE: Platform messages are asynchronous, so we initialize in an async method.
  void getSdkVersion() async {
    sdkVersion = await Freshchat.getSdkVersion;
  }

  Future<String> getFreshchatUserId() async {
    freshchatUserId = await Freshchat.getFreshchatUserId;
    //  FlutterClipboard.copy(freshchatUserId);
    return freshchatUserId;
  }

  void getUnreadCount() async {
    unreadCountStatus = await Freshchat.getUnreadCountAsyncForTags(["tags"]);
  }
  void logout() async {
    loading = true;
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
          loading = false;
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

  List order = [];
  DateTime? date;

  bool isLoading = false;
  String trending = 'today';

  void orderList() async {
    order.clear();
    isLoading = false;
    try {
      const url = '${Url}orders';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'limit': 10.toString(),
          'trending': trending,
        },
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          setState(() {
            order.addAll(data['data']);
            print('response----------->${order}');
            isLoading = true;
          });
        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
          setState(() {
            isLoading = true;
          });
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
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }

  var orders;
  var menu;
  var percent;
  var percent2;

  void totalorder() async {
    setState(() {
      isLoading = false;
    });
    try {
      const url = '${Url}total-orders-menus';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );

      // print('response----------->${response.body}');

      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          print('Data ----- > $data');

          setState(() {
            orders = data['data']['orders'] ?? '';
            menu = data['data']['foods'] ?? '';
            // print('--menu-----> $menu');
            // print('--orders-----> $orders');
          });
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = true;
          });
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
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
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }

  void AcceptDecline({String? StatusID, String? OrderID}) async {
    setState(() {
      isLoading = true;
    });
    try {
      String url =
          '${Url}order-accept-decline?order_id=$OrderID&status=$StatusID';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        // print('---->step 5-->  ${data['data']}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (data['success'] == true) {
            setState(() {
              isLoading = false;
              Navigator.pushReplacement(context,
                  NoBlinkPageRoute(builder: (context) => bottom_screen()));
            });
          } else {
            setState(() {
              isLoading = false;
            });
            String errorMessage = data['message'];
            print('error :-> $errorMessage');
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Errorrrr: $e');
    }
  }
  void handleFreshchatNotification(Map<String, dynamic> message) async {
    if (await Freshchat.isFreshchatNotification(message)) {
      print("is Freshchat notification");
      Freshchat.handlePushNotification(message);
    }
  }

  Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
    print("Inside background handler");

    //NOTE: Freshchat notification - Initialize Firebase for Android only.
    if (Platform.isAndroid) {
      await Firebase.initializeApp();
    }
    handleFreshchatNotification(message.data);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderList();
    totalorder();
    Freshchat.init(APPID, APPKEY, DOMAIN);
    Freshchat.linkifyWithPattern("google", "https://google.com");
    Freshchat.setNotificationConfig(
      notificationInterceptionEnabled: true,
      largeIcon: "large_icon",
      smallIcon: "small_icon",
    );
    if (Platform.isAndroid) {
      registerFcmToken();

      FirebaseMessaging.instance.onTokenRefresh
          .listen(Freshchat.setPushRegistrationToken);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        var data = message.data;
        handleFreshchatNotification(data);
        print("Notification Content: $data");
      });

      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }

    var restoreStream = Freshchat.onRestoreIdGenerated;
    restoreStreamSubscription = restoreStream.listen((event) async {
      print("Inside Restore stream: Restore Id generated");
      FreshchatUser user = await Freshchat.getUser;
      String? restoreId = user.getRestoreId();
      if (restoreId != null) {
        print("Restore Id: $restoreId");
        Clipboard.setData(new ClipboardData(text: restoreId));
      } else {
        restoreId = " ";
      }

/*      ScaffoldMessenger.of(context).showSnackBar(
          new SnackBar(content: new Text("Restore ID copied: $restoreId")));*/
    });

    //NOTE: Freshchat events
    var userInteractionStream = Freshchat.onUserInteraction;
    userInteractionStream.listen((event) {
      print("User Interacted $event");
    });
    var notificationStream = Freshchat.onNotificationIntercept;
    notificationStream.listen((event) {
      print(" Notification: $event");
    });
    var freshchatEventStream = Freshchat.onFreshchatEvents;
    fchatEventStreamSubscription = freshchatEventStream.listen((event) {
      print("Freshchat Event: $event");
    });
    var unreadCountStream = Freshchat.onMessageCountUpdate;
    unreadCountSubscription = unreadCountStream.listen((event) {
      print("New message generated: " + event.toString());
    });
    var linkOpeningStream = Freshchat.onRegisterForOpeningLink;
    linkOpenerSubscription = linkOpeningStream.listen((event) {
      print("URL clicked: $event");
    });

    getSdkVersion();
    getFreshchatUserId();
    getTokenStatus();
    getUnreadCount();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: Wid_Con.App_Bar(
            leading: Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  'assets/images/list.png',
                ),
              ),
            ),
            //  titel: Image.asset('assets/images/come_eat.png', fit: BoxFit.cover),
            fontweight: FontWeight.w600,
            actions: [
              SizedBox(
                width: 6.w,
              ),
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
            onPresprivacypolicy: () {
              Navigator.pop(context);
              Navigator.push(context,
                  NoBlinkPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
            },
            onPressedlogout: () {
              logout();
            }),
        body: loading != true
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment(0.5, 1),
                                  colors: [
                                    Color(0xFFC73C1B),
                                    Color(0xFFE49630),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      isLoading == false
                                          ? ''
                                          : (orders == null || order == "null")
                                              ? "0"
                                              : orders.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Total Orders',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                color: grey200,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      isLoading == false
                                          ? ''
                                          : (menu == null || menu == "null")
                                              ? "0"
                                              : menu.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: blue,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Total Menus',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: blue,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('Order List',
                            style: TextStyle(
                                fontSize: 16,
                                color: blue,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500)),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if(isLoading == true){
                              setState(() {
                                trending = 'today';
                                orderList();
                              });
                            }
                          },
                          child: trending == 'today'
                              ? Container(
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment(0.5, 1),
                                        colors: [
                                          Color(0xFFC73C1B),
                                          Color(0xFFE49630),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text('Today',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: white,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400)),
                                  ),
                                )
                              : Text('Today',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: grey,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if(isLoading == true){
                              setState(() {
                                trending = 'week';
                                orderList();
                              });
                            }
                          },
                          child: trending == 'week'
                              ? Container(
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment(0.5, 1),
                                        colors: [
                                          Color(0xFFC73C1B),
                                          Color(0xFFE49630),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text('Weekly',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: white,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400)),
                                  ),
                                )
                              : Text('Weekly',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: grey,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if(isLoading == true){
                              setState(() {
                                trending = 'month';
                                orderList();
                              });
                            }
                          },
                          child: trending == 'month'
                              ? Container(
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment(0.5, 1),
                                        colors: [
                                          Color(0xFFC73C1B),
                                          Color(0xFFE49630),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text('Monthly',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: white,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400)),
                                  ),
                                )
                              : Text('Monthly',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: grey,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isLoading == false
                        ? Column(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 70.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 70.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 70.0,
                                  color: Colors.white,
                                ),
                              ),
                              // Shimmer.fromColors(
                              //   baseColor: Colors.grey[300]!,
                              //   highlightColor: Colors.grey[100]!,
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width *  0.9,
                              //     height: 70.0,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ],
                          )
                        : order.isEmpty
                            ? Expanded(
                                child: Center(
                                child: Text(
                                  'No Data!',
                                  style: TextStyle(fontSize: 20, color: blue),
                                ),
                              ))
                            : Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    orderList();
                                  },
                                  color: orange,
                                  child: ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: order.length,
                                    itemBuilder: (context, i) {
                                      // Check if 'i' is less than 10 to limit the number of items displayed
                                      if (i < 10) {
                                        return Theme(
                                          data: ThemeData(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                NoBlinkPageRoute(
                                                  builder: (context) =>
                                                      Order_Manage_Screen(
                                                          id: order[i]['id']
                                                              .toString()),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.32,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              order[i]['order'][
                                                                          'user']
                                                                      ['name']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: blue,
                                                                fontFamily:
                                                                    fontfamily,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              DateFormat(
                                                                      'MMM d, yyyy h:mm')
                                                                  .format(DateTime.parse(order[
                                                                              i]
                                                                          [
                                                                          'order']
                                                                      [
                                                                      'created_at']))
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: grey,
                                                                fontFamily:
                                                                    fontfamily,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              order[i][
                                                                      'order_id']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: blue,
                                                                fontFamily:
                                                                    fontfamily,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "\u{20B9}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: greyfont,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 0.5.w,
                                                          ),
                                                          Text(
                                                            '${order[i]['price'].toStringAsFixed(2)}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: blue,
                                                              fontFamily:
                                                                  fontfamily,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      order[i]['order_accept_decline_status']
                                                              .isEmpty
                                                          ? Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Wid_Con.showAlertDialog(
                                                                            message: 'Are you sure want to Accept?',
                                                                            onPressed_no: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            onPressed_yes: () {
                                                                              AcceptDecline(OrderID: order[i]['id'].toString(), StatusID: '1');
                                                                              Navigator.pop(context);
                                                                            });
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 60,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      gradient:
                                                                          const LinearGradient(
                                                                        begin: Alignment
                                                                            .topRight,
                                                                        end: Alignment(
                                                                            0.5,
                                                                            1),
                                                                        colors: [
                                                                          Color(
                                                                              0xFFC73C1B),
                                                                          Color(
                                                                              0xFFE49630),
                                                                        ],
                                                                      ),
                                                                      color:
                                                                          grey300,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Accept',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              white,
                                                                          fontFamily:
                                                                              fontfamily,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Wid_Con.showAlertDialog(
                                                                            message: 'Are you sure want to Decline?',
                                                                            onPressed_no: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            onPressed_yes: () {
                                                                              AcceptDecline(OrderID: order[i]['id'].toString(), StatusID: '0');
                                                                              Navigator.pop(context);
                                                                            });
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 60,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      gradient:
                                                                          const LinearGradient(
                                                                        begin: Alignment
                                                                            .topRight,
                                                                        end: Alignment(
                                                                            0.5,
                                                                            1),
                                                                        colors: [
                                                                          Color(
                                                                              0xFFC73C1B),
                                                                          Color(
                                                                              0xFFE49630),
                                                                        ],
                                                                      ),
                                                                      color:
                                                                          grey300,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Decline',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              white,
                                                                          fontFamily:
                                                                              fontfamily,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(
                                                              height: 25,
                                                              width: 70,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 30,
                                                                      right:
                                                                          30),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF${order[i]['order_accept_decline_status']['bg_color'].toString().replaceAll("#", '')}")),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  '${order[i]['order_accept_decline_status']['status']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        white,
                                                                    fontFamily:
                                                                        fontfamily,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 0.5,
                                                  width: double.infinity,
                                                  color: grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Return an empty Container for items beyond the first 10
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Wid_Con.button(
                                ButtonName: 'Dine In Order',
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      NoBlinkPageRoute(
                                          builder: (context) =>
                                              const Orders_Screen(
                                                ordertype: 2,
                                              )));
                                },
                                height: 43,
                                ButtonRadius: 8,
                                ButtonColor: Colors.transparent,
                                titelcolor: white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Wid_Con.button(
                                ButtonName: 'Delivery Order',
                                ButtonRadius: 8,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      NoBlinkPageRoute(
                                          builder: (context) =>
                                              const Orders_Screen(
                                                ordertype: 1,
                                              )));
                                },
                                height: 43,
                                ButtonColor: Colors.transparent,
                                titelcolor: white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: blue,
                ),
              ),
      ),
    );
  }
}
