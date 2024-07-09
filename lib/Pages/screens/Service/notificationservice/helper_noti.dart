
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
 // NotificationProvider? _notificationProvider;
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance ;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();
  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message)async{

  //  const String iconPath = 'package:stock_market/assets/vector/logo.png';
    var androidInitializationSettings = const AndroidInitializationSettings('@drawable/img');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings ,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload){
          // handle interaction when app is active for android
          handleMessage(context, message);
        }
    );
  }

  void firebaseInit(BuildContext context){

    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;

      if (kDebugMode) {
        print(notification);
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        //   print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if(Platform.isIOS){
        forgroundMessage();
      }

      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
       // storeNotificationInSharedPreferences(message);
      }
    });
  }


  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true ,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString() ,
      importance: Importance.max  ,
      showBadge: true ,
      playSound: true,

    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString() ,
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high ,
        playSound: true,
        ticker: 'ticker' ,
        icon:'@drawable/img'

    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true ,
        presentBadge: true ,
        presentSound: true
    ) ;

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails ,
      );
    });

  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context)async{

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    //String notificationType = message.data['type'] ?? "";
    String notificationType = message.data['type'] ?? "";
    String NotificationT1 = message.data['type'] ?? "";
    String Notificationid = message.data['url'] ?? "";
    bool close_call = message.notification!.title!.contains("Trade Close");
    bool exit_call = message.notification!.title!.contains("Stoploss Occurred Exit");
    print("Trade is Close $close_call");
    print("Trade is Exit $exit_call");

//print(data.read);
  /*  if (notificationType.isNotEmpty) {
      //  String notificationType = notificationType;
      if (notificationType == "1") {
        if (exit_call) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Intraday_history(title: Notificationid.trim()),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Intraday_Live_Calls(
                title: Notificationid.trim(),
                call_index: close_call ? 1 : 0,
              ),
            ),
          );
        }
      } else if (notificationType == "2") {
        print("====> ${Notificationid}");
        if (exit_call) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Positional_history(title: Notificationid.trim()),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => positional_live_calls(
                title: Notificationid.trim(),
                call_index: close_call ? 1 : 0,
              ),
            ),
          );
        }
      } else if (notificationType == "11") {
        if (close_call || exit_call) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Short_history(title: Notificationid.trim()),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => short_term_live_calls(title: Notificationid.trim()),
            ),
          );
        }
      } else if (notificationType == "13") {
        if (close_call || exit_call) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Longterm_history(title: Notificationid.trim()),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => long_term_live_calls(title: Notificationid.trim()),
            ),
          );
        }
      } else if (notificationType == "12") {
        if (close_call || exit_call) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => midterm_history(title: Notificationid.trim()),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => mid_term_live_calls(title: Notificationid.trim()),
            ),
          );
        }
      } else if (notificationType == "3") {
        if (close_call || exit_call) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => midterm_history(title: Notificationid.trim()),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ipo_main(title: Notificationid.trim()),
            ),
          );
        }
      }
    }
*/

  }

 /* void storeNotificationInSharedPreferences(RemoteMessage message) {
    String notificationType = message.data['type'] ?? "";
    String NotificationT1 = message.data['type'] ?? "";
    String Notificationid = message.data['url'] ?? "";
    SharedPreferences.getInstance().then((prefs) {
      String notificationMessage = message.notification!.body.toString();
      notificationType = message.data['type'] ?? "";

      // Get current timestamp
      DateTime now = DateTime.now();
      String timestamp = now.toIso8601String();

      List<String> notificationsList = prefs.getStringList('notifications') ?? [];
      notificationsList.add(jsonEncode({
        "message": "$notificationMessage",
        "type": "$notificationType",
        "read": false,
        "title": "${message.notification!.title}",
        "call_type": "$NotificationT1",
        "id": "$Notificationid",
        "timestamp": timestamp // Add timestamp to the notification details
      }));
      prefs.setStringList('notifications', notificationsList);
      NotificationData notification = NotificationData(
          message: notificationMessage,
          type: notificationType,
          read: false,
          title: message.notification!.title.toString(),
          id: Notificationid,
          call_type: NotificationT1,
          timestamp: timestamp // Store timestamp in NotificationData object
      );
      // _notificationProvider!.addNotification(notification);
      // addNotification(notification);
    });
  }
*/

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


}