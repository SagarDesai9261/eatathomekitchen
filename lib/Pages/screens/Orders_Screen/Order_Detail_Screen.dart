import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:comeeathome/Pages/screens/Dashboard_screen/banner_image.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:direct_dialer/direct_dialer.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:sizer/sizer.dart';


import '../../../Constants/Custum_bottombar/Bottombar.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Payout_Screen/Addcard_screen.dart';
import '../Service/Privacy_policy.dart';
import 'Orders_Screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../bottombar_screen.dart';

import 'package:http/http.dart' as http;

class Order_Detail_Screen extends StatefulWidget {
  const Order_Detail_Screen({Key? key, this.id, this.isOrder}) : super(key: key);
  final id;
  final isOrder;

  @override
  State<Order_Detail_Screen> createState() => _Order_Detail_ScreenState();
}

class _Order_Detail_ScreenState extends State<Order_Detail_Screen> {

  TextEditingController descontroller = TextEditingController();
  TextEditingController MessageController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasFocus = false;
  List individual = [];
  late DirectDialer dialer;


  @override
  void initState() {
    super.initState();
    setupDialer();


    orderDetails();
  }
  Future<void> setupDialer() async => dialer = await DirectDialer.instance;

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    super.dispose();
  }

  String textdata = '';

  void logout() async {
    try {

      const url = '${Url}settings';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );

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

  Map foodList = {};
  bool isLoading  = false;

  void orderDetails() async {
    setState(() {
      isLoading = true;
    });
    // try {
      print('---->${widget.id}');
      final url = '${Url}order-detail/${widget.id}';
      print(url);
      print(storage.read('api_token_login'));
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );


        final data = json.decode(response.body);
        print(data);

    if(response.statusCode==200||response.statusCode==201) {
      if (data['success'] == true) {

        setState(() {
          foodList = data['data'];
          fulldish = data["data"]["full_dish"];
          print('-------client_is_verified---> ${foodList['client_is_verified']}');
          // SelectedStatusName = foodList['order_status']??'';
          if(foodList['order_accept_decline_status'].isNotEmpty){
            Orderstatus(ID: foodList['order_accept_decline_status']['status'],OrderStatus: foodList['order_status']);
          }else{
            Orderstatus();
          }

          isLoading = false;
        });
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


    // } catch (e) {
    //   // Handle other error scenarios like network issues or unexpected responses
    //   log('Errorrrr: $e');
    // }
  }

  List<String> Statusname = [];
  List orderStatus = [];
  List fulldish = [];
  String SelectedStatusName = '';
  String SelectedStatusID = '';
  TextEditingController statusController = TextEditingController();

  void Orderstatus({String? ID,String? OrderStatus}) async {
    print('---->step 1');
    setState(() {
      isLoading = true;
    });
    try {
      print('---->step 2');
      const url = '${Url}order-status';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':  'Bearer ${storage.read('api_token_login')}',
        },
      );
      print(url);
      print('---->step 3');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('---->step 4');
        final data = json.decode(response.body);
        print('---->step 5');

        if (data['success'] == true) {
          setState(() {
            orderStatus.addAll(data['data']);
            orderStatus.forEach((e) {
              Statusname.add(e['status']);
              if(ID.toString() != 'null'||ID.toString().isNotEmpty||ID.toString()!=''||OrderStatus.toString() != 'null'||OrderStatus.toString() != ''||OrderStatus.toString().isNotEmpty){
                // if(OrderStatus!.contains(ID!)){
                  for (var food in orderStatus) {
                    if (food['status'] == OrderStatus) {
                      setState(() {
                        statusController.text = food['status'];

                        SelectedStatusName = food['status'];
                        SelectedStatusID = food['id'].toString();
                        print('--------cuisine------> $SelectedStatusName');
                        print('--------cuisine------> $SelectedStatusID');
                      });
                      break; // Exit the loop once you find the matching food
                    }

                  }
                // }

              }
            });
          });
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
            builder: (context) => const login_screen(),
          ),
        );
        storage.remove('email_verified');
        storage.remove('api_token_login');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }

  void Updatestatus({String? ID}) async {
    print('---->step 1');
    setState(() {
      isLoading = true;
    });
    try {
      print('---->step 2');
      String url = '${Url}order-status-change?order_id=${widget.id}&status=$ID';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':  'Bearer ${storage.read('api_token_login')}',
        },
      );
      print(url);
      print(response.body);
      print('---->step 3');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('---->step 4');
        final data = json.decode(response.body);
        print('---->step 5-->  ${data['data']}');

        if (data['success'] == true) {
          setState(() {
            // Fluttertoast.showToast(
            //   msg: '${data['message']}',
            //   fontSize: 16,
            //   backgroundColor: black,
            //   gravity: ToastGravity.BOTTOM,
            //   textColor: white,
            // );
            Wid_Con.toastmsgg(context: context,msg:'${data['message']}');
            Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> Orders_Screen(orderdrawer: true,)));
          });
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
        setState(() {
          isLoading = false;
        });

      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Errorrrr: $e');
    }
  }



  Future<bool> _onWillPop() async {
    storage.remove('isOrdermen');
    storage.remove('isOrder');
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) => widget.isOrder==true?const Orders_Screen(orderdrawer: true,): const bottom_screen()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

   // List fulldish = foodList["fulldish"];
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
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
            titel: 'Order Details',
            fontweight: FontWeight.w600,
            ),
        drawer: Wid_Con.drawer(
            width: MediaQuery.of(context).size.width * 0.75,
            onPressedfav: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const Orders_Screen()));
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
              storage.remove('isOrdermen');
              storage.remove('isOrder');
              Navigator.pop(context);
              Navigator.push(
                  context,
                  NoBlinkPageRoute(
                      builder: (context) => const Orders_Screen(
                        orderdrawer: true,
                      )));
            },
            onPressedreview: () {
              storage.remove('isOrdermen');
              storage.remove('isOrder');
              Navigator.pop(context);
              Navigator.push(context,
                  NoBlinkPageRoute(builder: (context) => const ReviewSreen()));
            },
            onPressedpay: () {
              storage.remove('isOrdermen');
            storage.remove('isOrder');
              Navigator.pop(context);
              Navigator.push(
                  context,
                  NoBlinkPageRoute(
                      builder: (context) => const payoutDetails_screen()));
            },
            onPressedlan: () {
              storage.remove('isOrdermen');
              storage.remove('isOrder');
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const Orders_Screen()));
            },
            onPressedad: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  NoBlinkPageRoute(
                      builder: (context) => const add_discount()));
            },
            onPressedlogout: () {
              storage.remove('isOrdermen');
              storage.remove('isOrder');
              logout();
            }),
        bottomNavigationBar: const Bottombar(),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: isLoading == true ? Center(child: CircularProgressIndicator(color: blue),) : Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: SingleChildScrollView(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: orange),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Type',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Wid_Con.button(
                                            ButtonName: foodList['order_type'] ?? '',
                                            onPressed: () {},
                                            height: 25,
                                            width: 70,
                                            titelcolor: white,
                                            fontSize: 6.sp,
                                            ButtonRadius: 5),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Order Time',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          foodList['order_time'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Client',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              foodList['client_name'] ?? '',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: greyfont,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Image.asset('assets/images/verify.png',height: 16,),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Payment Status',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          foodList['payment_status'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Date',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          foodList['order_date'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Order Status',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          foodList['order_status'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Order ID',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          foodList['order_id'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Dish',
                                style: TextStyle(
                                    fontFamily: fontfamily,
                                    fontSize: 12,
                                    color: bluefont,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              /*Container(
                                height:200,
                                child: ListView.builder(
                                  itemCount: fulldish.length,
                                  itemBuilder: (context,index){

                                  return   Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Food',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          fulldish[index]['food_name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Quantity',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          fulldish[index]['food_quantity'].toString() ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "\u{20B9}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: greyfont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 0.5.w,),
                                            Text(
                                              fulldish[index]['food_price'].toString() ?? '',
                                              // '${foodList['full_dish']['food_price'].toStringAsFixed(2)}' ?? '',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: greyfont,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Extra',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: bluefont,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          fulldish[index]['extra'] == '' ? '-' : fulldish[index]['extra'],
                                          //foodList['full_dish']['extra']==''?'-':foodList[0]['data']['full_dish']['extra'] ?? '-',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: greyfont,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                                  },),
                              ),*/
                              Container(
                                constraints: BoxConstraints(maxHeight: double.infinity),
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: Column(
                                    children: [
                                      // Table header
                                     /* Container(
                                        padding: EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Name',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Price',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),

                                            // Expanded(
                                            //   flex: 3,
                                            //   child: Text(
                                            //     'Extra',
                                            //     textAlign: TextAlign.center,
                                            //     style: TextStyle(
                                            //       fontSize: 12,
                                            //       color: bluefont,
                                            //       fontFamily: 'Poppins',
                                            //       fontWeight: FontWeight.w500,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),*/
                                      // Table data
                                      ...fulldish.map((item) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${
                                                  item['food_quantity']
                                                      .toString()
                                                } x  ${item['food_name']} ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: greyfont,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "\u{20B9}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: blue,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text('${(item["food_price"] * item["food_quantity"] )}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: blue,
                                                          fontFamily: fontfamily)),
                                                ],
                                              ),

                                              // Expanded(
                                              //   flex: 3,
                                              //   child: Text(
                                              //     item['extra'].isEmpty ? '-' : item['extra'],
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //       fontSize: 12,
                                              //       color: greyfont,
                                              //       fontFamily: 'Poppins',
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),



                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                          foodList['individual_items'].isNotEmpty?
                          ListView.builder(
                            itemCount: foodList['individual_items'].length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              final INDitem = foodList['individual_items'][i];
                              print('------ind--> $INDitem');
                              return  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 0.5,
                                    width: double.infinity,
                                    color: grey,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Individual Items',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 12,
                                        color: bluefont,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              INDitem['food_name'] ?? '',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: greyfont,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Quantity',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              INDitem['food_quantity'].toString() ?? '',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: greyfont,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "\u{20B9}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: greyfont,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 0.5.w,),
                                                Text(
                                                  '${INDitem['food_price'].toString()}' ?? '',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: greyfont,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                ],
                              );
                          },) :
                            Container(),

                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: grey,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub total',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: bluefont,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "\u{20B9}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: greyfont,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w,),
                                  Text(
                                    '${foodList['sub_total'].toStringAsFixed(2)}' ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color(0xFFD97627),
                                      fontFamily: fontfamily,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                'Delivery Fee',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: bluefont,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\u{20B9}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: greyfont,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w,),
                                  Text(
                                    '${foodList['delivery_fee'].toStringAsFixed(2)}' ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color(0xFFD97627),
                                      fontFamily: fontfamily,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                'Applied Coupon(${foodList['coupon_code']})',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: bluefont,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\u{20B9}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: greyfont,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w,),
                                  Text(
                                    '${foodList['coupon_amoun']}' ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color(0xFFD97627),
                                      fontFamily: fontfamily,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tax (${foodList['tax'].toString()}%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: bluefont,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "\u{20B9}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: greyfont,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w,),
                                  Text(
                                    '${foodList['tax_amount'].toStringAsFixed(2)}' ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color(0xFFD97627),
                                      fontFamily: fontfamily,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),


                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: grey,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: bluefont,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                               Row(mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text(
                                     "\u{20B9}",
                                     style: TextStyle(
                                       fontSize: 14,
                                       color: greyfont,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                   SizedBox(width: 0.5.w,),
                                   Text(
                                    '${foodList['total'].toStringAsFixed(2)}' ?? '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: const Color(0xFFD97627),
                                        fontFamily: fontfamily,
                                        fontWeight: FontWeight.w600),
                              ),
                                 ],
                               ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // foodList['order_accept_decline_status'].isEmpty?
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Wid_Con.button(
                          //       ButtonName: 'Accept',
                          //       onPressed: () {
                          //         showDialog<void>(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return Wid_Con.showAlertDialog(
                          //                 message: 'Are you sure want to Accept?',
                          //                 onPressed_no: (){
                          //                   Navigator.pop(context);
                          //                 },
                          //                 onPressed_yes: (){
                          //                   AcceptDecline(OrderID:storage.read('isOrdermen'),StatusID: '1');
                          //                   Navigator.pop(context);
                          //                 });
                          //           },
                          //         );
                          //       },
                          //       width: 90,
                          //       height: 35,
                          //       titelcolor: white,
                          //       fontSize: 12,
                          //     ),
                          //     const SizedBox(
                          //       width: 10,
                          //     ),
                          //     InkWell(
                          //       borderRadius: BorderRadius.circular(5),
                          //       onTap: (){
                          //         showDialog<void>(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return Wid_Con.showAlertDialog(
                          //                 message: 'Are you sure want to Decline?',
                          //                 onPressed_no: (){
                          //                   Navigator.pop(context);
                          //                 },
                          //                 onPressed_yes: (){
                          //                   AcceptDecline(OrderID:storage.read('isOrdermen'),StatusID: '0');
                          //                   Navigator.pop(context);
                          //                 });
                          //           },
                          //         );
                          //       },
                          //       child: Container(
                          //         height: 35,
                          //         width: 80,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(5),
                          //           border: Border.all(color: blue),
                          //         ),
                          //         child: Center(
                          //           child: Text(
                          //             'Decline',
                          //             style: TextStyle(fontSize: 12, color: blue),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ):
                          // foodList['order_accept_decline_status']['status']!='Accepted'?
                          // Container(
                          //   height: 35,
                          //   width: 128,
                          //   decoration: BoxDecoration(
                          //     color: Color(int.parse("0xFF${foodList['order_accept_decline_status']['bg_color'].toString().replaceAll("#", '')}")),
                          //     borderRadius:
                          //     BorderRadius
                          //         .circular(
                          //         30),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       '${foodList['order_accept_decline_status']['status']}',
                          //       style:
                          //       TextStyle(
                          //         fontSize: 14,
                          //         color: white,
                          //         fontFamily:
                          //         fontfamily,
                          //       ),
                          //     ),
                          //   ),
                          // ):
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: SizedBox(
                          //         height: 35,
                          //         child: CustomDropdown(
                          //           borderRadius: BorderRadius.circular(4),
                          //           borderSide: BorderSide(color: grey300),
                          //           hintText: SelectedStatusName.isEmpty
                          //               ? 'Select Status'
                          //               : SelectedStatusName,
                          //           selectedStyle: TextStyle(
                          //               fontSize: 13, color: grey),
                          //           hintStyle: TextStyle(
                          //               fontSize: 13, color: grey),
                          //           items: Statusname.isEmpty ? [''] : Statusname,
                          //           controller: statusController,
                          //           onChanged: (value) {
                          //             setState(() {
                          //               for (var order in orderStatus) {
                          //                 if (order['status'] == value) {
                          //                   setState(() {
                          //                     statusController.text = order['status'];
                          //
                          //                     SelectedStatusName = value;
                          //                     SelectedStatusID = order['id'].toString();
                          //                     print('--------cuisine------> $SelectedStatusName');
                          //                     print('--------cuisine------> $SelectedStatusID');
                          //                   });
                          //                   break; // Exit the loop once you find the matching food
                          //                 }
                          //               }
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     Wid_Con.button(
                          //       ButtonName: 'Submit',
                          //       onPressed: (){
                          //         if(SelectedStatusName.isNotEmpty){
                          //           showDialog<void>(
                          //             context: context,
                          //             builder: (BuildContext context) {
                          //               return Wid_Con.showAlertDialog(
                          //                   message: 'Are you sure want to $SelectedStatusName?',
                          //                   onPressed_no: (){
                          //                     Navigator.pop(context);
                          //                   },
                          //                   onPressed_yes: (){
                          //                     Updatestatus(ID: SelectedStatusID);
                          //                     Navigator.pop(context);
                          //                   });
                          //             },
                          //           );
                          //         }else{
                          //           // Fluttertoast.showToast(
                          //           //   msg: 'Please select status',
                          //           //   fontSize: 16,
                          //           //   backgroundColor: black,
                          //           //   gravity: ToastGravity.BOTTOM,
                          //           //   textColor: white,
                          //           // );
                          //           Wid_Con.toastmsgr(context: context,msg:'Please select status');
                          //         }
                          //       },
                          //       width: 100,
                          //       height: 35,
                          //       titelcolor: white,
                          //       ButtonRadius: 5,
                          //       fontSize: 12,
                          //     )
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 25,
                          // ),
                          // Text(
                          //   'Customer Request',
                          //   style: TextStyle(
                          //       fontSize: 12,
                          //       color: bluefont,
                          //       fontFamily: 'Poppins',
                          //       fontWeight: FontWeight.w500),
                          // ),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // Container(
                          //   height: 100,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: grey300),
                          //   ),
                          //   child: Html(
                          //     data:  storage.read('textdata') ?? '',
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // Container(
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: grey300),
                          //   ),
                          // ),
                          const SizedBox(height: 25),
                          // Text(
                          //   'Message',
                          //   style: TextStyle(
                          //       fontFamily: fontfamily,
                          //       fontSize: 12,
                          //       color: bluefont,
                          //       fontWeight: FontWeight.w500),
                          // ),
                          // const SizedBox(height: 15),
                          // TextFormField(
                          //   maxLines: 5,
                          //   style: TextStyle(color: grey),
                          //   controller: MessageController,
                          //   decoration: InputDecoration(
                          //     // isDense: true,
                          //       hintText: 'Message',
                          //       hintStyle: TextStyle(
                          //           color: grey300
                          //       ),
                          //       contentPadding:
                          //       const EdgeInsets.symmetric(
                          //           horizontal: 10,
                          //           vertical: 10),
                          //       focusedBorder: OutlineInputBorder(
                          //           borderRadius:
                          //           BorderRadius.circular(5),
                          //           borderSide: BorderSide(
                          //               color: grey300,
                          //               width: 1)),
                          //       enabledBorder: OutlineInputBorder(
                          //         borderRadius:
                          //         BorderRadius.circular(5),
                          //         borderSide: BorderSide(
                          //             color: grey300, width: 1),
                          //       ),
                          //       border: OutlineInputBorder(
                          //         borderRadius:
                          //         BorderRadius.circular(5),
                          //       ),
                          //       suffixIconColor: grey),
                          // ),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Wid_Con.button(
                          //         ButtonName: 'Submit',
                          //         onPressed: () {
                          //           storage.write('textdata', textdata);
                          //           print(textdata);
                          //           MessageController.clear();
                          //         },
                          //         width: 80,
                          //         height: 35,
                          //         titelcolor: white,
                          //         fontSize: 10,
                          //         fontWeight: FontWeight.w500)
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Wid_Con.button(
    //                     ButtonName: '',
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                     },
    //                     width: 130,
    //                     height: 35,
    //                     titelcolor: white,
    //                     fontSize: 13,
    //                     ButtonRadius: 5,
    //                     fontWeight: FontWeight.w500,
    //                     child: Row(
    //                       children: [
    //                         Image.asset('assets/images/backtolist.png', height: 15),
    //                         Text('  Back to List',
    //                             style: TextStyle(fontSize: 12, color: white)),
    //                       ],
    //                     ),
    //                   ),
    //                   Wid_Con.button(
    //                     ButtonName: '',
    //                     onPressed: () async {
    //                       if (Platform.isAndroid || Platform.isIOS) {
    //                         if (foodList['client_phone'].isNotEmpty||foodList['client_phone']!='') {
    //                           await dialer.dial(foodList['client_phone']);
    //                         }else{
    //                           Wid_Con.toastmsgr(context: context,msg:'Mobile number not found',);
    //                         }
    //                       }else if(DirectDialer.onIpad || Platform.isMacOS){
    //                         if (foodList['client_phone'].isNotEmpty||foodList['client_phone']!='') {
    //                           final dialer = await DirectDialer.instance;
    //                           await dialer.dialFaceTime(foodList['client_phone'], true);
    //                         }else{
    //                           Wid_Con.toastmsgr(context: context,msg:'Mobile number not found',);
    //                         }
    // }
    //
    //                     },
    //                     width: 130,
    //                     height: 35,
    //                     titelcolor: white,
    //                     fontSize: 13,
    //                     ButtonRadius: 5,
    //                     fontWeight: FontWeight.w500,
    //                     child: Row(
    //                       children: [
    //                         Image.asset('assets/images/calltouser.png', height: 18),
    //                         Text('  Call to User',
    //                             style: TextStyle(fontSize: 12, color: white)),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //
    //               const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
