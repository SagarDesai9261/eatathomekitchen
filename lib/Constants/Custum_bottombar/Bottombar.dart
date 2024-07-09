import 'dart:async';
import 'dart:convert';

import 'package:comeeathome/Pages/test.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../Constants/App_Colors.dart';
import '../../Pages/screens/Login_Screen/Start_Screen.dart';
import '../../Pages/screens/bottombar_screen.dart';
import '../Widget.dart';


class Bottombar extends StatefulWidget {
  const Bottombar({super.key, this.index_});
final index_;
  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int? pageIndex;
  bool? isActive;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKitchen();
  }
  void getKitchen() async {
    const url = '${Url}details';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );
    final data = json.decode(response.body);
    if(response.statusCode==200||response.statusCode==201) {
      if (data['success'] == true) {
        setState(() {
          print('------- 1');

          if(data['data']['active']==false){
            storage.write('isActive', false);
            setState(() {
              isActive = false;
            });
          }else{
            storage.write('isActive', false);
            setState(() {
              isActive = true;
            });
          }
          storage.write('IsKitchen', false);
        });
      } else {
        setState(() {
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
  @override
  Widget build(BuildContext context) {
    var keyOne = GlobalKey<NavigatorState>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      color: const Color(0XFF000000).withOpacity(0.2),
      child: WillPopScope(
          onWillPop: () async => !await keyOne.currentState!.maybePop(),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Theme(
                  data: ThemeData(
                    splashColor: transparent,
                    highlightColor: transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      storage.remove('isOrdermen');
                      storage.remove('isOrder');
                      Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen()));
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/dashboard.png',
                                height: 18,
                                color: pageIndex == 0 ? orange : grey),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color:
                                  pageIndex == 0 ? orange : greyfont,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData(
                    splashColor: transparent,
                    highlightColor: transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      storage.remove('isOrdermen');
                      storage.remove('isOrder');
                      Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen(pageindex: 1,)));
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/food.png',
                                height: 18,
                                color: pageIndex == 1 ? orange : grey),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Foods",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color:
                                  pageIndex == 1 ? orange : greyfont,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Theme(
                      data: ThemeData(
                        splashColor: transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: StatefulBuilder(
                        builder: (context, setState) =>  InkWell(
                          onTap: ()async {

                            print('-----------------------------------> isbottom');
                            const url = '${Url}details';
                            final response = await http.get(
                              Uri.parse(url),
                              headers: {
                                'Authorization': 'Bearer ${storage.read('api_token_login')}',
                              },
                            );
                            final data = json.decode(response.body);

                            if(response.statusCode==200||response.statusCode==201) {
                              if (data['success'] == true) {
                                if(data['data']['active']==false){
                                  // Fluttertoast.showToast(
                                  //   msg: 'Your account is under verification process.',
                                  //   fontSize: 16,
                                  //   backgroundColor: black,
                                  //   gravity: ToastGravity.TOP,
                                  //   textColor: white,
                                  // );
                                  Wid_Con.toastmsgr(context: context,msg:'Your account is under verification process.',);
                                  setState(() {
                                    isActive = false;
                                  });
                                }else{
                                  storage.remove('isOrdermen');
                                  storage.remove('isOrder');
                                  Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen(pageindex: 2)));
                                  pageIndex = 2;
                                  setState(() {
                                    isActive = true;
                                  });
                                }
                                storage.write('IsKitchen', false);
                                // iskitchenDetail = false;
                                print('------------------------Activ---------------> ${storage.read('isActive')}');

                              } else {
                                // Fluttertoast.showToast(
                                //   msg: 'Your account is under verification process.',
                                //   fontSize: 16,
                                //   backgroundColor: black,
                                //   gravity: ToastGravity.TOP,
                                //   textColor: white,
                                // );
                                Wid_Con.toastmsgr(context: context,msg:'Your account is under verification process.',);
                                storage.write('IsKitchen', true);
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


                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient:  LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment(0.5, 1),
                                  colors:isActive==true? [
                                    Color(0xFFC73C1B),
                                    Color(0xFFE49630),
                                  ]:[grey,grey],
                                ),
                              ),
                              child: Center(
                                child:
                                Icon(Icons.add, color: white, size: 25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData(
                    splashColor: transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      storage.remove('isOrdermen');
                      storage.remove('isOrder');
                      Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen(pageindex: 3,)));
                      setState(() {
                        pageIndex = 3;
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/noti.png',
                                height: 18,
                                color: pageIndex == 3 ? orange : grey),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Notification",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color:
                                  pageIndex == 3 ? orange : greyfont,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      storage.remove('isOrdermen');
                      storage.remove('isOrder');
                      Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen(pageindex: 4,)));
                      setState(() {
                        pageIndex = 4;
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/prifile.png',
                                height: 18,
                                color: pageIndex == 4 ? orange : grey),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "My Profile",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color:
                                  pageIndex == 4 ? orange : greyfont,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
