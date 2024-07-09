import 'dart:convert';
import 'dart:developer';
import 'package:comeeathome/Constants/Custum_bottombar/Bottombar.dart';
import 'package:comeeathome/Pages/screens/Food_Screen/addfood_screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../../Constants/App_Colors.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import '../../../main.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import 'Addcard_screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../bottombar_screen.dart';

class PayoutScreen extends StatefulWidget {
  String? name;
  String? card_number;
  String? cvv;
  String? expiry_date;
   PayoutScreen({Key? key,this.name,this.card_number,this.cvv,this.expiry_date}) : super(key: key);

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isChecked = false;
  bool isVisible = true;
  TextEditingController Name = TextEditingController();
  TextEditingController Number = TextEditingController();
  TextEditingController Expiry = TextEditingController();
  TextEditingController Cvv = TextEditingController();
  String addSpacesToCardNumber(String cardNumber) {
    RegExp regExp = RegExp(r'\d{4}');
    Iterable<Match> matches = regExp.allMatches(cardNumber);

    List<String> groups = matches.map((match) => match.group(0)!).toList();
    String formattedCardNumber = groups.join('   ');

    return formattedCardNumber;
  }

  void logout() async {
    try {

      const url = '${Url}settings';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );
      print('${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          setState(() {

          });

          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            NoBlinkPageRoute(
              builder: (context) => const start_screen(),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) => bottom_screen()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    print(addSpacesToCardNumber(widget.card_number.toString()));
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            // titel: 'Eat At Home',
            // fontweight: FontWeight.w600,
            actions: [
              SizedBox(width: 6.w,),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         NoBlinkPageRoute(
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
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
            },
            onpressBannerimage: () {
              Navigator.pop(context);
              Navigator.push(context,
                  NoBlinkPageRoute(builder: (context) =>  ImageSelectionScreen()));
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
                      builder: (context) => const AddCardScreen()));
            },
            onPressedlan: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
            },
            onPressedad: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  NoBlinkPageRoute(
                      builder: (context) => const add_discount()));
            },
            onPressedlogout: () {
              logout();
              setState(() {
                isVisible = !isVisible;
              });
            }),
        bottomNavigationBar: Bottombar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Card',
                style: TextStyle(
                    fontFamily: fontfamily,
                    fontSize: 18,
                    color: bluefont,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment(0.5, 2),
                      colors: [
                        Color(0xFFE49630),
                        Color(0xFFC73C1B),
                      ],
                    )),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Lorem Card',
                                style: TextStyle(
                                    fontFamily: fontfamily,
                                    fontSize: 17,
                                    color: white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'ABCDE',
                                style: TextStyle(
                                    fontFamily: fontfamily,
                                    fontSize: 17,
                                    color: white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${addSpacesToCardNumber(widget.card_number.toString())}',
                                style: TextStyle(
                                    fontFamily: fontfamily,
                                    fontSize: 18,
                                    color: white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Expanded(child: Container(
                      color: white100,
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CARD HOLDER',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 10,
                                        color: white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${widget.name}',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 12,
                                        color: white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPIRED',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 10,
                                        color: white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${widget.expiry_date}',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 12,
                                        color: white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                )
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Payout Details',
                style: TextStyle(
                    fontFamily: fontfamily,
                    fontSize: 18,
                    color: bluefont,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            NoBlinkPageRoute(
                                builder: (context) =>
                                const payoutDetails_screen()));
                      },
                      child: Container(
                        height: 50,
                        color: transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                  fontFamily: fontfamily,
                                  fontSize: 16,
                                  color: grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '+ \u{20B9} 480',
                              style: TextStyle(
                                  fontFamily: fontfamily,
                                  fontSize: 16,
                                  color: orange,
                                  fontWeight: FontWeight.w600),
                            ),

                          ],
                        ),
                      ),
                    );
                  },)),
              Wid_Con.button(
                  ButtonName: 'Payout',
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //         const Orders_Screen(
                    //           ordertype: 1,
                    //         )));
                  },
                  height: 50,
                  width: double.infinity,
                  ButtonColor: Colors.transparent,
                  titelcolor: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ],
          ),
        ),
      ),
    );
  }
}
