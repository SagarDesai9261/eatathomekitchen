import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:comeeathome/Constants/Custum_bottombar/Bottombar.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:comeeathome/Pages/screens/Dashboard_screen/dashboard_screen.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Payout_Screen/Addcard_screen.dart';
import '../Service/Privacy_policy.dart';
import 'Order_Management_Screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';


class Orders_Screen extends StatefulWidget {
  const Orders_Screen({Key? key, this.ordertype, this.orderdrawer}) : super(key: key);
  final ordertype;
  final orderdrawer;


  @override
  State<Orders_Screen> createState() => _Orders_ScreenState();
}

class _Orders_ScreenState extends State<Orders_Screen> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  String selectedCategory = 'Select Status'; // Default category
  String selectedCategoryID = ''; // Default category
  DateTime? startDate;
  DateTime? endDate;
  String selected_range = '';
  var typeofapi;

  List order = [];
  DateTime? date;
  bool isLoading = false;
  bool? onTap;

  String? trending;

  void orderList({String? statusID,String? startDate,String? endDate, String? searchtext }) async {
    order.clear();
    isLoading = false;
    var response;
    print(storage.read('type').toString());

    // try {
      print('---->step 2 ${ storage.read('type').toString()=='null'?'':storage.read('type').toString()}');
      var url = '${Url}orders';
      var url1 = '${Url}orders?text_search=$searchtext';
      var url2 = '${Url}orders?order_status_id=$statusID&order_start_date=$startDate&order_end_date=$endDate';
      if(typeofapi=='simple'){
        print('---------type--> $url');
        response = await http.post(
          Uri.parse(url),
          body: {
            'trending': trending!.isEmpty?'':trending,
            'type': storage.read('type').toString()=='null'?'':storage.read('type').toString(),
          },
          headers: {
            'Authorization': 'Bearer ${storage.read('api_token_login')}',
          },
        );
      }else if(typeofapi=='search'){
        print('---------type--> $url1');
        response = await http.post(
          Uri.parse(url1),
          body: {
            'trending': trending!.isEmpty?'':trending,
            'type': storage.read('type').toString()=='null'?'':storage.read('type').toString(),
          },
          headers: {
            'Authorization': 'Bearer ${storage.read('api_token_login')}',
          },
        );
    }else if(typeofapi=='filter'){
        print('---------type--> $url2');
        response = await http.post(
          Uri.parse(url2),
          body: {
            'trending': trending!.isEmpty?'':trending,
            'type': storage.read('type').toString()=='null'?'':storage.read('type').toString(),
          },
          headers: {
            'Authorization': 'Bearer ${storage.read('api_token_login')}',
          },
        );
      }

      // print('response----------->${response.body}');

      final data = json.decode(response.body);
      if(response.statusCode==200||response.statusCode==201) {
        if (data['success'] == true) {
          setState(() {
            order.addAll(data['data']);

            isLoading = true;
          });
          //log('-------order-----> $order');
          //log('-------trending-----> $trending');
        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
          setState(() {
            isLoading = true;
          });
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

  void logout() async {
    try {
      const url = '${Url}settings';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );
   //   print('${response.body}');
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
    setState(() {
      typeofapi = 'simple';
    });
    trending = widget.orderdrawer!=true? 'today':'';
    if(widget.orderdrawer!=true){
      if(widget.ordertype == 2){
        onTap = true;
      }else{
        onTap = false;
      }
    }else{
      print('is------order---->${widget.ordertype}');
    }
    storage.write('type', widget.ordertype.toString());
    orderList();
  }

  void AcceptDecline({String? StatusID,String? OrderID}) async {
    setState(() {
      isLoading = true;
    });
    // try {
      String url = '${Url}order-accept-decline?order_id=$OrderID&status=$StatusID';
      print('-----url--> $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':  'Bearer ${storage.read('api_token_login')}',
        },
      );
  //  print('1--> ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('1.1--> ');
        final data = json.decode(response.body);
        print('---->step 5-->  ${data['data']}');
        print('1.2--> ');
        if (data['success'] == true) {
          setState(() {
            print('1.3--> ');
            isLoading = false;
            Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const Orders_Screen(orderdrawer: true,)));
          });
        } else {
          print('1.0.1--> ');
          setState(() {
            isLoading = false;
          });
          print('1.0.2--> ');
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
          print('1.0.3--> ');
        }
      }else if(response.statusCode==401||response.statusCode==400){
        print('2.1--> ');
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) => const start_screen(),
          ),
        );
        print('2.2--> ');
        storage.remove('email_verified');
        storage.remove('api_token_login');
      } print('3--> ');
    // } catch (e) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   log('Errorrrr: $e');
    // }
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) =>  const bottom_screen()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop:_onWillPop,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: Wid_Con.App_Bar(
              leading: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Image.asset(
                    'assets/images/list.png',
                  ),
                ),
              ),
              // titel: 'Eat At Home',fontweight: FontWeight.w600,
              actions: [
                SizedBox(width: 6.w,),
                // IconButton(
                //
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
              ],
            ),
            drawer: Wid_Con.drawer(
                width: MediaQuery.of(context).size.width * 0.75,
                onPressedfav: () {
                  Navigator.pop(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
                },onPressedorder: (){
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
            },onPressedreview: (){
              Navigator.pop(context);
              Navigator.push(context,
                  NoBlinkPageRoute(builder: (context) => const ReviewSreen()));
            },onPressedpay: (){
              Navigator.pop(context);
              Navigator.push(context,
                  NoBlinkPageRoute(builder: (context) => const payoutDetails_screen()));
            },onPressedlan: (){
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
            },
                onPresprivacypolicy: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      NoBlinkPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
                },
                onpressBannerimage: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      NoBlinkPageRoute(builder: (context) =>  ImageSelectionScreen()));
                },
                onPressedad: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context, builder: (context) =>add_discount());
                },
                onPressedlogout: () {
                  logout();
                }),
            bottomNavigationBar: const Bottombar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: TextFormField(
                            controller: controller,
                            cursorColor: grey,
                            onTap: () {
                              setState(() {
                                typeofapi = 'search';
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                orderList(searchtext: value);
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: grey, width: 1)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: grey, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                //fillColor: grey200,
                                //filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                hintText: 'Search by Id, name and email',
                                hintStyle: TextStyle(
                                    color: grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Poppins'),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: grey,
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Wid_Con.button(
                        ButtonName: '',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            typeofapi = 'filter';
                          });
                          filter_dialog_box();
                        },
                        height: 40,
                        width: 60,
                        ButtonRadius: 5,
                        child: Center(
                          child: Image.asset('assets/images/list2.png', height: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            storage.write('type', 2.toString());
                            isLoading = false;
                            orderList();
                            onTap = true;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            color: onTap != true ?  greybox : grey300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Dine In',
                              style: TextStyle(
                                  fontSize: 12, color: blue, fontFamily: fontfamily),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: (){
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            storage.write('type', 1.toString());
                            isLoading = false;
                            orderList();
                            onTap = false;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            color: onTap != false ?  greybox : grey300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('Delivery',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: fontfamily)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Text('Order ID',
                          style: TextStyle(
                              fontSize: 16,
                              color: blue,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(isLoading == true){
                            setState(() {
                              trending = 'today';
                              orderList();
                            });
                          }

                        },
                        child:trending == 'today'? Container(
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
                        ): Text('Today',
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(isLoading == true){
                            setState(() {
                              trending = 'week';
                              orderList();
                            });
                          }
                        },
                        child:trending == 'week'? Container(
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
                        ):Text('Weekly',
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(isLoading == true){
                            setState(() {
                              trending = 'month';
                              orderList();
                            });
                          }
                        },
                        child:trending == 'month'?Container(
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
                        ): Text('Monthly',
                            style: TextStyle(
                                fontSize: 12,
                                color: grey,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400)),
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  isLoading == false
                      ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: blue),
                    ),
                  )
                      :order.isEmpty ? Expanded(child: Center(child: Text('No Data!',style: TextStyle(fontSize: 20,color: blue),),)) : Expanded(
                    child: RefreshIndicator(
                      onRefresh: ()async {
                        orderList();
                      },
                      color: orange,
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: order.length ,
                        itemBuilder: (context, i) {
                          return Theme(
                            data: ThemeData(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: InkWell(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                              //  print(order[i]['order_accept_decline_status']['status']);
                                Navigator.push(
                                  context,
                                  NoBlinkPageRoute(
                                    builder: (context) =>
                                        Order_Manage_Screen(id: order[i]['id'].toString(),isOrder: true),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.32,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order[i]['order']
                                                ['user']['name'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: blue,
                                                  fontFamily: fontfamily,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                DateFormat('MMM d, yyyy h:mm').format(DateTime.parse(order[i]['order']['created_at'])).toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: grey,
                                                  fontFamily: fontfamily,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: 5),
                                              Text(
                                                order[i]['order_id'].toString(),
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
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\u{20B9}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: blue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              ' ${order[i]['price'].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: blue,
                                                fontFamily: fontfamily,
                                              ),
                                            ),
                                          ],
                                        ),
                                        order[i]['order_accept_decline_status'].isEmpty?
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                showDialog<void>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Wid_Con.showAlertDialog(
                                                        message: 'Are you sure want to Accept?',
                                                        onPressed_no: (){
                                                          Navigator.pop(context);
                                                        },
                                                        onPressed_yes: (){
                                                          AcceptDecline(StatusID: '1',OrderID: order[i]['id'].toString());
                                                          Navigator.pop(context);
                                                        });
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment(0.5, 1),
                                                    colors: [
                                                      Color(0xFFC73C1B),
                                                      Color(0xFFE49630),
                                                    ],
                                                  ),
                                                  color: grey300,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      30),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: white,
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
                                              onTap: (){
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                showDialog<void>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Wid_Con.showAlertDialog(
                                                        message: 'Are you sure want to Decline?',
                                                        onPressed_no: (){
                                                          Navigator.pop(context);
                                                        },
                                                        onPressed_yes: (){
                                                          AcceptDecline(StatusID: '0',OrderID: order[i]['id'].toString());
                                                          Navigator.pop(context);
                                                        });
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment(0.5, 1),
                                                    colors: [
                                                      Color(0xFFC73C1B),
                                                      Color(0xFFE49630),
                                                    ],
                                                  ),
                                                  color: grey300,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      30),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Decline',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: white,
                                                      fontFamily:
                                                      fontfamily,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ):
                                        Container(
                                          height: 25,
                                          width: 70,
                                          margin: const EdgeInsets.only(left: 30,right: 30),
                                          decoration: BoxDecoration(
                                            color: Color(int.parse("0xFF${order[i]['order_accept_decline_status']['bg_color'].toString().replaceAll("#", '')}")),
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
                                                fontSize: 10,
                                                color: white,
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

                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.orange,
            disabledColor: Colors.grey,
            //primaryColor: Colors.blue,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          _startDateController.text =
          "${startDate!.toLocal().toString().split(' ')[0]}";
        } else {
          endDate = pickedDate;
          _endDateController.text =
          "${endDate!.toLocal().toString().split(' ')[0]}";
        }
      });
    }
  }

  filter_dialog_box() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            titlePadding:  EdgeInsets.only(top: 15,bottom: 20,left: 10,right: 10),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Order'),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close))
              ],
            ),
            actions: <Widget>[
              SizedBox(
                height: 165,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                        const EdgeInsets.only(right: 10, left: 10),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      elevation: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select game';
                        } else {
                          return null;
                        }
                      },
                      isExpanded: true,
                      hint: const Text("Selected Status"),
                      iconSize: 30,
                      iconEnabledColor: Colors.black,
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 15,
                      ),
                      value: selectedCategory,
                      items: <String>[
                        'Select Status',
                        'Accepted',
                        'Declined'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                          if (selectedCategory == 'Accepted') {
                            selectedCategoryID = 7.toString();
                          } else if (selectedCategory == 'Declined') {
                            selectedCategoryID = 6.toString();
                          }else if (selectedCategory == 'Select Status') {
                            selectedCategoryID = '';
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Choose Date for order",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _startDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context, true),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _endDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: 'End Date',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context, false),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Wid_Con.button(
                ButtonName: '',
                onPressed: () {
                  orderList(
                    startDate: _startDateController.text,
                    endDate: _endDateController.text,
                    statusID: selectedCategoryID
                  );
                  Navigator.pop(context);

                },
                height: 40,
                width: 100,
                ButtonRadius: 5,
                child: const Center(
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
