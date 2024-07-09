
import 'dart:convert';
import 'dart:developer';
import 'package:comeeathome/Pages/screens/Food_Screen/addfood_screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payout_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../Constants/App_Colors.dart';
import '../../../Constants/Custum_bottombar/Bottombar.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import '../../../main.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../bottombar_screen.dart';


class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isChecked = false;
  bool isVisible = true;
  TextEditingController Name = TextEditingController();
  TextEditingController Number = TextEditingController();
  TextEditingController Expiry = TextEditingController();
  TextEditingController Cvv = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> bottom_screen()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        appBar: Wid_Con.App_Bar(
            leading: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: (){
                  scaffoldKey.currentState?.openDrawer();
                },
                child: Image.asset(
                  'assets/images/list.png',
                ),
              ),
            ),
            // titel: 'Eat At Home',fontweight: FontWeight.w600,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, NoBlinkPageRoute(builder: (context)=> const profile_screen()));
                },
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: grey,
                ),
              )
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
            onPressedorder: (){
          Navigator.pop(context);
          Navigator.push(context,
              NoBlinkPageRoute(builder: (context) => const Orders_Screen(orderdrawer: true,)));
        },
            onPressedreview: (){
          Navigator.pop(context);
          Navigator.push(context,
              NoBlinkPageRoute(builder: (context) => const ReviewSreen()));
        },
            onPressedpay: (){
          Navigator.pop(context);
          Navigator.push(context,
              NoBlinkPageRoute(builder: (context) => const payoutDetails_screen()));
        },
            onPressedlan: (){
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Your Card',
                  style: TextStyle(
                      fontFamily: fontfamily,
                      fontSize: 18,
                      color: bluefont,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15,),
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
                  child: Center(
                    child: Image(image: AssetImage('assets/images/Scan.png'),height: 80,),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Card Holder’s Name',
                  style: TextStyle(
                      fontFamily: fontfamily,
                      fontSize: 16,
                      color: greyfont,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: Name,
                  style: TextStyle(color: bluefont),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: grey,
                      fontSize: 14
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: grey200)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: bluefont)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Card No.',
                  style: TextStyle(
                      fontFamily: fontfamily,
                      fontSize: 16,
                      color: greyfont,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: Number,
                  style: TextStyle(color: bluefont),
                  decoration: InputDecoration(
                    hintText: 'Card no.',
                    hintStyle: TextStyle(
                        color: grey,
                        fontSize: 14
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: grey200)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: bluefont)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expiry Date',
                            style: TextStyle(
                                fontFamily: fontfamily,
                                fontSize: 16,
                                color: greyfont,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(5),
                              new CardExpirationFormatter()
                            ],
                            controller: Expiry,

                            style: TextStyle(color: bluefont),
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              hintStyle: TextStyle(
                                  color: grey,
                                  fontSize: 14
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: grey200)
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: bluefont)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CVV',
                            style: TextStyle(
                                fontFamily: fontfamily,
                                fontSize: 16,
                                color: greyfont,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            controller: Cvv,
                            obscureText: isVisible,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(3),
                            ],
                            style: TextStyle(color: bluefont),
                            decoration: InputDecoration(
                              hintText: '***',
                              hintStyle: TextStyle(
                                  color: grey,
                                  fontSize: 14
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: grey200)
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: bluefont)
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: !isVisible
                                      ? Image.asset(
                                    'assets/images/visible_off.png',
                                    height: 15,
                                  )
                                      : Image.asset('assets/images/visible_on.png',
                                      height: 15),
                                ),
                              ),
                            ),

                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                          unselectedWidgetColor: Colors.blue),
                      child: Checkbox(
                        //fillColor: MaterialStateProperty.all(trans),
                        activeColor: Colors.blue,
                        value: isChecked,
                        checkColor: white,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            print('------------Cvv---> ${Expiry.text}');
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Save this card for faster payments',
                        style: TextStyle(
                            fontSize: 15,
                            color: bluefont,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),

                Wid_Con.button(
                    ButtonName: 'Add Your Card',
                    onPressed: () {
                      Navigator.push(
                          context,
                          NoBlinkPageRoute(
                              builder: (context) =>
                               PayoutScreen(name: Name.text,expiry_date: Expiry.text,cvv: Cvv.text,card_number:Number.text ,)));
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
      ),
    );

  }
}


class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}