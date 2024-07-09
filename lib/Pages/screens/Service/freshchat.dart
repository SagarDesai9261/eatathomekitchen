// freshchat_service.dart
import 'dart:convert';

import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
class FreshchatService {

  FreshchatService(){
    _initFreshchat();
  }

  final String APPID = "ccd5820a-d45f-4698-8c06-81be62a9b153";
  final String APPKEY = "32d74b1d-29ff-40ed-9355-2b97c0b20670";
  final String DOMAIN = "msdk.in.freshchat.com";

  FreshchatUser user = FreshchatUser("","");
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

  void _initFreshchat() async {
   // user = await Freshchat.getUser;
    Freshchat.init(APPID, APPKEY, DOMAIN);
    Freshchat.linkifyWithPattern("google", "https://google.com");
    Freshchat.setNotificationConfig(
      notificationInterceptionEnabled: true,
      largeIcon: "large_icon",
      smallIcon: "small_icon",
    );

    if (Platform.isAndroid) {
      await _registerFcmToken();

      FirebaseMessaging.instance.onTokenRefresh
          .listen(Freshchat.setPushRegistrationToken);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        var data = message.data;
        _handleFreshchatNotification(data);
        print("Notification Content: $data");
      });

      FirebaseMessaging.onBackgroundMessage(_myBackgroundMessageHandler);
    }

    _subscribeToStreams();

    print(user == null);
    await _loadData();
    await _getSdkVersion();
    await _getFreshchatUserId();
    await _getTokenStatus();
    await _getUnreadCount();
    await _getUser();
  }

  void _subscribeToStreams() {
    restoreStreamSubscription = Freshchat.onRestoreIdGenerated.listen((event) async {
      print("Inside Restore stream: Restore Id generated");
      FreshchatUser user = await Freshchat.getUser;
      String restoreId = user.getRestoreId() ?? "";
      print("Restore Id: $restoreId");
     // Clipboard.setData(ClipboardData(text: restoreId));
    });

    userInteractionSubscription = Freshchat.onUserInteraction.listen((event) {
      print("User Interacted $event");
    });

    notificationClickSubscription = Freshchat.onNotificationIntercept.listen((event) {
      print("Notification: $event");
    });

    fchatEventStreamSubscription = Freshchat.onFreshchatEvents.listen((event) {
      print("Freshchat Event: $event");
    });

    unreadCountSubscription = Freshchat.onMessageCountUpdate.listen((event) {
      print("New message generated: " + event.toString());
    });

    linkOpenerSubscription = Freshchat.onRegisterForOpeningLink.listen((event) {
      print("URL clicked: $event");
    });
  }

  Future<void> _registerFcmToken() async {
    if (Platform.isAndroid) {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token is generated $token");
      if (token != null) {
        Freshchat.setPushRegistrationToken(token);
      }
    }
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Support id: " + prefs.getString('support_ticket_id').toString());
  }

  void _handleFreshchatNotification(Map<String, dynamic> data) {
    // Handle Freshchat notification data
  }

  static Future<void> _myBackgroundMessageHandler(RemoteMessage message) async {
    // Handle background message
  }

  Future<void> _getUser() async {
    user = await Freshchat.getUser;
  }

  Future<String> _getTokenStatus() async {
    JwtTokenStatus jwtStatus = await Freshchat.getUserIdTokenStatus;
    jwtTokenStatus = jwtStatus.toString().split('.').last;
    return jwtTokenStatus;
  }

  Future<void> _getSdkVersion() async {
    sdkVersion = await Freshchat.getSdkVersion;
  }

  Future<void> _getFreshchatUserId() async {
    freshchatUserId = await Freshchat.getFreshchatUserId;
  }

  Future<void> _getUnreadCount() async {
    unreadCountStatus = await Freshchat.getUnreadCountAsyncForTags(["tags"]);
  }

  void showConversations() async {

      //Navigator.of(context).pushNamed('/Help');
      if (storage.read("api_token_login") != null) {
        //print("supportTicketId   ::"+supportTicketId.toString());
        /* if(supportTicketId.toString() == "null")
                  {
                    createChat();
                  }
                else
                  {
                     fetchTicketDetails(supportTicketId);
                  }
*/

        // Freshchat.getFreshchatUserId;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String restoreId = storage.read("restoreid");

        if (restoreId == null) {
          // Generate a new restore ID
          // FreshchatUser user = await Freshchat.getUser;
          //   restoreId = user.getRestoreId();
          FreshchatUser user = await Freshchat.getUser;
          restoreId = user.getRestoreId()!;
        }
        print("restoreId :- ${restoreId}");
        // restoreId = await Freshchat.getFreshchatUserId;
        String value = restoreId;
        print(storage.read("name"));
        print(storage.read("email"));
        if(user != null){
          user.setFirstName(storage.read("name") ?? "");
          user.setEmail(storage.read("email") ?? "");
          if (restoreId == ""){
            Freshchat.identifyUser(externalId:storage.read("email"));
          }
          else
          {
            Freshchat.identifyUser(externalId:storage.read("email"),restoreId: restoreId);
          }


          print("object ==> $value");
          Freshchat.setUser(user!);


          Freshchat.showConversations(filteredViewTitle:"Premium Support",tags:["premium"]);
        }
        //user!.setPhone("+91", currentUser.value.phone);

        print("object restore if ${ restoreId == ""}");
        if (restoreId == "") {
          // Generate a new restore ID

          FreshchatUser user = await Freshchat.getUser;
          restoreId = user.getRestoreId()!;
          // restoreId = await Freshchat.getFreshchatUserId;
          await prefs.setString('restoreId', restoreId);
          await saveRestoreId(restoreId);
        }

        /*  //  String value = await Freshchat.getFreshchatUserId;
                user.setFirstName(currentUser.value.name);
                user.setEmail(currentUser.value.email);
                user.setPhone("+91", currentUser.value.phone);*/
        //  Freshchat.identifyUser(externalId:currentUser.value.email,restoreId: "a0e01ac6-b7b9-4b4b-a3d1-61c3f4208c0b");

      }
    


    
    //Freshchat.showConversations();
  }

  void showFAQs() {
   // Freshchat.showFAQs();
  }

  void dispose() {
    restoreStreamSubscription?.cancel();
    fchatEventStreamSubscription?.cancel();
    unreadCountSubscription?.cancel();
    linkOpenerSubscription?.cancel();
    notificationClickSubscription?.cancel();
    userInteractionSubscription?.cancel();
  }
  Future<void> saveRestoreId(String restoreId) async {

    final String url = 'https://eatathome.in/app/api/kitchen/save-restorid';
    print(url);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${storage.read("api_token_login")}',
      },
      body: jsonEncode({'restoreid': restoreId}),
    );
    print(response.body);
    if (response.statusCode == 200 || json.decode(response.body)["success"] == true) {
      storage.write("restoreid", json.decode(response.body)['data']["restoreid"]);
      // Request was successful
    //  setCurrentUser(response.body);
    //  currentUser.value = userModel.User.fromJSON(json.decode(response.body)['data']);
    } else {
      // Handle error
      print('Failed to save Restore ID: ${response.statusCode}');
      print('Error: ${response.body}');
    }
  }

}
