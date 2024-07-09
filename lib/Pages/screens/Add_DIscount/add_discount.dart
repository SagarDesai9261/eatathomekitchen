import 'dart:convert';
import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/App_Colors.dart';
import '../../../Constants/Custum_bottombar/Bottombar.dart';
import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Payout_Screen/payoutDetails_screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Service/Privacy_policy.dart';
import '../bottombar_screen.dart';

class add_discount extends StatefulWidget {
  const add_discount({super.key});

  @override
  State<add_discount> createState() => _add_discountState();
}

class _add_discountState extends State<add_discount> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVisible = true;
  List<String> adoption = ["Fixed","Percent"];
  TextEditingController adoptionn = TextEditingController();
  TextEditingController adoptionn2 = TextEditingController();
  var result;
  String bottom_msg = '';

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
          setState(() {});
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


  @override
  void initState() {
    // TODO: implement initState
    get_discount_details();
    super.initState();
  }

  void get_discount_details() async {
    setState(() {
      isLoading = true;
    });
    const url = '${Url}kitchen-discount/list';
    var request = http.MultipartRequest(
        'POST', Uri.parse(url))
      ..headers.addAll(
        {
          "Authorization":
          "Bearer ${storage.read('api_token_login')}"
        },
      );
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Request was successful, parse the response
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        print('Response: $data');
        result = data['data'];
        if(result['fixed_percentage']=='Percent'){
          setState(() {
            bottom_msg=" ${result['discount']} %";
            isLoading = false;
          });
        }
        else
          {
            setState(() {
              bottom_msg="${result['discount']}";
              isLoading = false;
            });
          }


      } else {
        // Request failed, print the error code and message
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      // An error occurred while sending the request
      print('Error sending request: $e');
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) => bottom_screen()))) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
   // print(result["status"]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child:isLoading == true
          ? Center(
        child: CircularProgressIndicator(color: blue),
      ): GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: Wid_Con.App_Bar(
              leading: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Image.asset(
                    'assets/images/list.png',
                  ),
                ),
              ),
              titel: 'ADD DISCOUNT',
              fontweight: FontWeight.w600,
              actions: [
                SizedBox(width: 6.w,)
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
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const Orders_Screen()));
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
              onpressBannerimage: () {
                Navigator.pop(context);
                Navigator.push(context,
                    NoBlinkPageRoute(builder: (context) =>  ImageSelectionScreen()));
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
              onPresprivacypolicy: () {
                Navigator.pop(context);
                Navigator.push(context,
                    NoBlinkPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
              },
              onPressedlogout: () {
                logout();
                setState(() {
                  isVisible = !isVisible;
                });
              }),
          bottomNavigationBar: const Bottombar(),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              :
          Center(child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: Container(
              padding: EdgeInsets.zero,
              height: 330,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  // Divider(color: grey, thickness: 0.5),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    child:CustomDropdown(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: grey300),
                      hintText: "Select Type",
                      selectedStyle: TextStyle(
                          fontSize: 13, color: grey),
                      hintStyle: TextStyle(
                          fontSize: 13, color: grey),
                      items: adoption,
                      controller: adoptionn,
                      onChanged: (value) {
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 45,
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: fontfamily,
                      ),
                      controller: adoptionn2,keyboardType: TextInputType.number,
                      cursorColor: Colors.white,

                      decoration: InputDecoration(
                        isDense: true,
                         hintText: 'Insert discount amount',
                        hintStyle: TextStyle(
                          color: grey,
                          fontSize: 13,
                          fontFamily: fontfamily,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: grey300, width: 1)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: grey300, width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Wid_Con.button(
                            ButtonName: 'Cancel',
                            onPressed: (){
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.of(context).pop();
                            },
                            ButtonRadius: 5,
                            titelcolor: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Wid_Con.button(
                            ButtonName: 'Submit',
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if(adoptionn.text.isEmpty){
                                Wid_Con.toastmsgr(context: context,msg:"Select type");
                              }
                              else if(adoptionn2.text.isEmpty){
                                Wid_Con.toastmsgr(context: context,msg:"Discount amount Required !");
                              }
                              else
                                {

                                  const url = '${Url}kitchen-discount/save';
                                  var request = http.MultipartRequest(
                                      'POST', Uri.parse(url))
                                    ..headers.addAll(
                                      {
                                        "Authorization":
                                        "Bearer ${storage.read('api_token_login')}"
                                      },
                                    );
                                  request.fields['fixed_percentage'] = adoptionn.text;
                                  request.fields['discount'] =adoptionn2.text;

                                  try {
                                    var response = await request.send();
                                    if (response.statusCode == 200) {
                                      // Request was successful, parse the response
                                      var responseBody = await response.stream.bytesToString();
                                      var data = jsonDecode(responseBody);
                                      print('Response: $data');
                                      result = data['data'];
                                      Wid_Con.toastmsgg(context: context,msg:data['message']);
                                      Navigator.of(context).pushReplacement(
                                        NoBlinkPageRoute(
                                          builder: (context) => const add_discount(),
                                        ),
                                      );

                                    } else {
                                      // Request failed, print the error code and message
                                      print('Request failed with status: ${response.statusCode}');
                                      print('Response body: ${await response.stream.bytesToString()}');
                                    }
                                  } catch (e) {
                                    // An error occurred while sending the request
                                    print('Error sending request: $e');
                                  }


                                }
                            },
                            ButtonRadius: 5,
                            titelcolor: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  bottom_msg!=""  ?Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Your current discount is",
                            style: TextStyle(
                              fontFamily: fontfamily,
                              fontSize: 14,
                              color: bluefont,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            result['fixed_percentage']!='Percent'?" \u{20B9} ":"",
                            style: TextStyle(
                              fontSize: 15,
                              color: bluefont,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            bottom_msg,
                            style: TextStyle(
                              fontFamily: fontfamily,
                              fontSize: 14,
                              color: bluefont,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Wid_Con.showAlertDialog(
                                  message: 'Are you sure want to Delete?',
                                  onPressed_no: (){
                                    Navigator.pop(context);
                                  },
                                  onPressed_yes: () async {
                                    const url = '${Url}kitchen-discount/delete';
                                    var request = http.MultipartRequest(
                                        'POST', Uri.parse(url))
                                      ..headers.addAll(
                                        {
                                          "Authorization":
                                          "Bearer ${storage.read('api_token_login')}"
                                        },
                                      );
                                    try {
                                      var response = await request.send();
                                      if (response.statusCode == 200) {
                                        // Request was successful, parse the response
                                        var responseBody = await response.stream.bytesToString();
                                        var data = jsonDecode(responseBody);
                                        print('Response: $data');
                                        result = data['data'];
                                        Wid_Con.toastmsgg(context: context,msg:data['message']);

                                      } else {
                                        // Request failed, print the error code and message
                                        print('Request failed with status: ${response.statusCode}');
                                        print('Response body: ${await response.stream.bytesToString()}');
                                    }
                                    } catch (e) {
                                    // An error occurred while sending the request
                                    print('Error sending request: $e');
                                    }
                                    Navigator.of(context).pushReplacement(
                                      NoBlinkPageRoute(
                                        builder: (context) => const add_discount(),
                                      ),
                                    );

                                    // Navigator.pop(context);
                                  });
                            },
                          );



                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: grey300),
                          ),
                          child: Center(
                            child: Icon(Icons.delete, color: orange),
                          ),
                        ),
                      ),
                    ],
                  ):SizedBox(),
                  SizedBox(height: 10,),
                  if(result !=  null)
                  if(result["status"] == "0" )
                    Center(child: Text("Waiting For Approval",style: TextStyle(
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Poppins',
              color: red,
             )))

                ],
              ),
            ),
          ),)
        ),
      ),
    );
  }
  String formateddate(String date) {
    DateTime formated = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(formated).toString();
  }
}
