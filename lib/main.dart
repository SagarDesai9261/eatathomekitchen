import 'dart:convert';
import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'Pages/screens/Login_Screen/Login_Screen.dart';
import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'Pages/screens/Service/notificationservice/local_notification_service.dart';

import 'dart:io';
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
Future _getUserCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if(permission.name.toString() == 'denied'){
    await Geolocator.requestPermission();
    notificationService.requastNotificationPermission();
  }
  print('------permission----> ${permission.name}');
  // await Geolocator.requestPermission().then((value) {
  //
  // }).onError((error, stackTrace){
  //   print("Permission Error---> $error");
  // });
  // return await Geolocator.getCurrentPosition();
}



LocalNotificationService notificationService = LocalNotificationService();
void main() async {
  //HttpClient httpClient = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  await GetStorage.init();
  _getUserCurrentLocation();
  // storage.remove('email_verified');
  print('-----a--------> ${storage.read('email_verified')}');
  var login_ = storage.read('email_verified');
  print(login_);

  runApp(
    // DevicePreview(
    //   builder: (context) =>
    Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(

            // home: login_ == null ? const start_s0creen() : const PayoutScreen(),
              home: login_ == '0'||login_==null ?  login_screen() :  bottom_screen(pageindex: storage.read('IsKitchen')==true?4:0),
              debugShowCheckedModeBanner: false,
             // useInheritedMediaQuery: true,
              theme:ThemeData(
                useMaterial3 : false
              )
          );
        }),
    // ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}




// import 'package:comeeathome/Constants/App_Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  List _list = [];
  int _currentPage = 0;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData(int pageKey) async {
    setState(() {

      _isLoading = true;
      _error = 'null';

    });
    try {
      final response = await http.get(Uri.parse('https://eatathome.in/app/api/kitchen/foods?limit=6&offset=$pageKey'), headers: {
        'Authorization': 'Bearer c36F98uh9HVGwPW5hX2mUZfvYPLCpD15rpUqcvxw8e0cj1wRzskWbVjybF7r',
      },);
      if (response.statusCode == 200) {
        setState(() {
          final data = json.decode(response.body);
          data['data'].forEach((e) {
            _list.add(e['name']);
          });

          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _currentPage+= 6;
      _fetchData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Scrolling Example with Loading and Error States'),
      ),
      body: _error != 'null'
          ? Center(child: Text('Error: $_error'))
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 20.0,
                  mainAxisExtent: 270),
              controller: _scrollController,
              itemCount: _list.length + (_isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == _list.length) {
                  return Container(
                      height: 150,
                      width: 150,
                      color: grey,
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return Container(
                    color: grey,
                    child: ListTile(
                      title: Text(_list[index].toString()),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}