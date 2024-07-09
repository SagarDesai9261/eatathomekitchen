import 'dart:convert';
import 'dart:developer';

import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:comeeathome/Constants/Custum_bottombar/Bottombar.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/withdraw_history_page.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:comeeathome/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Orders_Screen/Order_Detail_Screen.dart';
import '../Orders_Screen/Order_Management_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import 'package:http/http.dart' as http;
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../Service/Privacy_policy.dart';

class payoutDetails_screen extends StatefulWidget {
  const payoutDetails_screen({Key? key}) : super(key: key);


  @override
  State<payoutDetails_screen> createState() => _payoutDetails_screenState();
}

class _payoutDetails_screenState extends State<payoutDetails_screen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String trending = 'month';
  String total_balance = "";
  String total_amount = "";
  String total_order = "";
  String total_withdraw = "";
  String minimum_amount = "";
  List order_data = [];
  TextEditingController amountController = TextEditingController();
  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Format the DateTime object into "dd-mm-yyyy" format
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void Payoutdata() async {
    try {

      const url = '${Url}payout';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );
      print('${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          setState(() {
               total_amount = data["data"]["total_amount"].toString();
               total_balance = data["data"]["payout_amount_amount"].toString();
               total_order = data["data"]["total_orders"].toString();
               minimum_amount = data["data"]["minimum_withdraw_amount"].toString();
               total_withdraw = data["data"]["withdraw_amount"].toString();
          });

          // ignore: use_build_context_synchronously

        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
        }
      }else if(response.statusCode==401||response.statusCode==400){

      }
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }
  void PayoutOrderdata() async {
    try {

      const url = '${Url}payout-orders';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
        body:{
          "trending":trending
        }

      );
      print(url);
      print('${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          setState(() {
            order_data = data["data"]["orders"];
          });

          // ignore: use_build_context_synchronously

        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
        }
      }else if(response.statusCode==401||response.statusCode==400){

      }
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
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
    Payoutdata();
    PayoutOrderdata();
  }
  Future<void> _refreshData() async {
    // Simulate a delay to mimic fetching new data from a data source
    Payoutdata();
    PayoutOrderdata();
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> bottom_screen()));
        return true;
      },
      child: SafeArea(
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
              // titel: 'Eat At Home',fontweight: FontWeight.w600,
              actions: [
                SizedBox(width: 6.w,),
                // IconButton(
                //   onPressed: () {},
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
              },onPressedorder: (){
            Navigator.pop(context);
            Navigator.push(context,
                NoBlinkPageRoute(builder: (context) => const Orders_Screen(orderdrawer: true,)));
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
          body: RefreshIndicator(
            color: orange,
            onRefresh: _refreshData,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Minimum Payout',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontfamily,
                                  color: bluefont,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              " \u{20B9}",
                              style: TextStyle(
                                fontSize: 18,
                                color: blue,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${minimum_amount}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontfamily,
                                  color: bluefont,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment(0.2, 1),
                              colors: [
                                Color(0xFFC73C1B),
                                Color(0xFFE49630),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8), // Optional: Adjust the border radius as needed
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              withdraw_dialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20), // Optional: Adjust padding as needed
                              backgroundColor: Colors.transparent, // Set the button's background color to transparent
                              elevation: 0, // Optional: Remove elevation
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Optional: Adjust the border radius to match the container
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Payout", style: TextStyle(color: Colors.white)), // Optional: Set text color
                                Icon(Icons.account_balance_wallet, size: 20, color: Colors.white), // Optional: Set icon color
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment(0.2, 1),
                                      colors: [
                                        Color(0xFFC73C1B),
                                        Color(0xFFE49630),
                                      ],
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Balance',
                                        style: TextStyle(
                                            fontFamily: fontfamily,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.list_alt,size: 20,color: Colors.white,),
                                          const SizedBox(width: 7,),
                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\u{20B9}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${total_balance}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: fontfamily,
                                                    fontWeight: FontWeight.w600,
                                                    color: white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PayoutHistoryPage()));
                                },
                                child: Container(
                                  height: 70,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment(0.2, 1),
                                        colors: [
                                          Color(0xFFC73C1B),
                                          Color(0xFFE49630),
                                        ],
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Withdraw',
                                          style: TextStyle(
                                              fontFamily: fontfamily,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.account_balance_wallet,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 7,),
                                            Container(
                                             // color: Colors.orange,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "\u{20B9}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${total_withdraw}',
                                                    style: TextStyle(
                                                        fontFamily: fontfamily,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: grey200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Orders',
                                        style: TextStyle(
                                            fontFamily: fontfamily,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: bluefont),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset('assets/images/totalorders.png',height: 14),
                                          const SizedBox(width: 7,),
                                          Text(
                                            '${total_order}',
                                            style: TextStyle(
                                                fontFamily: fontfamily,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: orange),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: grey200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            fontFamily: fontfamily,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: bluefont),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset('assets/images/totalamount.png',height: 14),
                                          const SizedBox(width: 7,),
                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\u{20B9}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: orange,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${total_amount}',
                                                style: TextStyle(
                                                    fontFamily: fontfamily,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: orange),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 0.5,
                      color: grey300,
                      width: double.infinity,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [

                        const Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              trending = 'month';
                            });
                            PayoutOrderdata();
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
                          ): Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Monthly',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: grey,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              trending = 'week';
                            });
                            PayoutOrderdata();
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
                          ):Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Weekly',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: grey,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              trending = 'today';
                            });
                            PayoutOrderdata();
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
                          ): Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Today',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: grey,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    order_data.length == 0 ? Container(
                        margin: EdgeInsets.only(top: 80),
                        child: Center(child: Text("No Data",style: TextStyle(
                            fontSize: 15,
                            color: blue,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500)),)) :

                    Container(
                      constraints: BoxConstraints(maxHeight: double.infinity),
                      child: SingleChildScrollView(
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(2), // ID column
                            1: FlexColumnWidth(4), // Date column
                            2: FlexColumnWidth(3), // Total column
                            3: FlexColumnWidth(3), // Base Total column
                            4: FlexColumnWidth(3), // Payout Amount column
                          },
                        //  border: TableBorder.all(color: Colors.grey),
                          children: [
                            // Table header
                            TableRow(
                              children: [
                                TableCell(child: Center(child: Text('ID', style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500)))),
                                TableCell(child: Center(child: Text('Date', style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500)))),
                                TableCell(child: Center(child: Text('Total', style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500)))),
                                TableCell(child: Center(child: Text('Base Total', style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500)))),
                                TableCell(child: Center(child: Text('Payout ', style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500)))),
                              ],
                            ),
                            // Table data
                            ...order_data.map((order) {
                              String formattedOrderDate = formatDate(order["food_orders"][0]["order_date"].toString());
                              return

                                TableRow(
                                  decoration: BoxDecoration(
                                  border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade300),
                              ),),
                                  children: [
                              TableCell(child: Center(child: InkWell(
                                  onTap: () {
                                Navigator.push(
                                  context,
                                  NoBlinkPageRoute(
                                    builder: (context) => Order_Detail_Screen(id: order["food_orders"][0]["order_id"].toString(), isOrder: false),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('#${order["id"]}', style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: fontfamily)),
                              ),
                              ))),
                              TableCell(child: Center(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('$formattedOrderDate',style:  TextStyle(
                                    fontSize: 12,
                                    color: blue,
                                    fontFamily: fontfamily),),
                              ))),
                              TableCell(child: Center(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
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
                                    Text('${order["total"]}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: blue,
                                            fontFamily: fontfamily)),
                                  ],
                                ),
                              ))),
                              TableCell(child: Center(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child:  Row(
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
                                    Text('${order["base_total"]}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: blue,
                                            fontFamily: fontfamily)),
                                  ],
                                ),
                              ))),
                              TableCell(child: Center(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('+ ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: blue,
                                            fontFamily: fontfamily)),
                                    Text(
                                      "\u{20B9}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text('${order["payout_amount"]}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: blue,
                                            fontFamily: fontfamily)),
                                  ],
                                ),
                              ))),
                              ],
                              );
                            }).toList(),
                          ],
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
      ),
    );
  }
  withdraw_dialog(BuildContext context){
    return showDialog(
        context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Withdraw Amount',style:TextStyle(
              fontSize: 16,
              color: bluefont,
              fontFamily: fontfamily,
              fontWeight: FontWeight.w500)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                        fontSize: 12,
                        color: bluefont,
                        fontFamily: fontfamily,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      style: TextStyle(color: grey),
                      controller: amountController,
                      cursorColor: grey,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),

                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: grey300, width: 1)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: grey300, width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel',style: TextStyle(color: orange),),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment(0.2, 1),
                  colors: [
                    Color(0xFFC73C1B),
                    Color(0xFFE49630),
                  ],
                ),
                borderRadius: BorderRadius.circular(8), // Optional: Adjust the border radius as needed
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20), // Optional: Adjust padding as needed
                  backgroundColor: Colors.transparent, // Set the button's background color to transparent
                  elevation: 0, // Optional: Remove elevation
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Optional: Adjust the border radius to match the container
                ),
                onPressed: () {
                  // Add logic to request payout
                  String amount = amountController.text;
                  if(double.parse(total_balance).round() < int.parse(minimum_amount)){
                    Wid_Con.toastmsgr(context: context,msg: "Insufficient balance",);
                  }
                  else if(int.parse(amount).round()< int.parse(minimum_amount)){
                    Wid_Con.toastmsgr(context: context,msg: "Minimum Payout is ${minimum_amount}",);
                   }
                  else if(int.parse(amount) > double.parse(total_balance).round()){
                    Wid_Con.toastmsgr(context: context,msg: "Maximum Payout is ${total_balance}",);
                  }
                   else{
                     requestPayout();
                     print('Payout requested for $amount');
                   }
                  // Validate the amount and proceed with payout request

                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Request Payout'),
              ),
            ),
          ],
        );
      }
    );
  }
  Future<void> requestPayout() async {
    const url = '${Url}payout';

    String apiUrl = url;
    String amount = amountController.text;
    Map<String, dynamic> requestData = {'amount': 100};
    print(requestData);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "amount":amountController.text
        },
          headers: {
            'Authorization': 'Bearer ${storage.read('api_token_login')}',
          },
      );
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          // Show success message
          Wid_Con.toastmsgg(context: context,msg: responseData['message'],);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(responseData['message']),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        //  Navigator.of(context).pop(); // Close the dialog
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request payout. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }

  }
}
