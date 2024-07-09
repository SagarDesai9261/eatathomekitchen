import 'dart:convert';
import 'dart:developer';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:comeeathome/Pages/screens/Food_Screen/addfood_screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../Constants/App_Colors.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Payout_Screen/Addcard_screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../Service/Privacy_policy.dart';
import '../bottombar_screen.dart';

import 'package:http/http.dart' as http;

class food_screen extends StatefulWidget {
  const food_screen({Key? key}) : super(key: key);

  @override
  State<food_screen> createState() => _food_screenState();
}

class _food_screenState extends State<food_screen> {
  String _range = '';
  String selected_range = '';
  String _selectedDate = '';
  String _dateCount = '';
  String _rangeCount = '';
  List<String> DatesOfCal = [];
  bool? isDate;
  String isfilter = 'alldata';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
    setState(() {
      DatesOfCal.clear();
      DatesController.selectedDates?.forEach((e) {
        DatesOfCal.add(DateFormat('dd-MM-yyyy').format(e));
        // DatesOfCal.add(DateFormat('dd-MM-yyyy').format(e));
      });
      isDate = true;
    });

    // String date = DateFormat('EEEE, MMM d, yyyy').format(DatesController.selectedDates);
    print('--------------Date----------> ${DatesOfCal.toSet().toList()}');
  }

  DateRangePickerController DatesController = DateRangePickerController();
  List<DateTime> dates = [];
  final _scrollController = ScrollController();
  List food = [];
  List foodies = [];
  bool isLoading = false;
  bool _isLoading = false;
  List _filteredContacts = [];
  DateTime? _startDate;
  DateTime? _endDate;
  int currentPage = 0;
  String _error = '';

/*
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }
*/

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    foodlist(pagekey: currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> foodlist(
      {var CateID,
      String? Foodtype,
      String? Start_date,
      String? End_date,
      var pagekey}) async {
    print('-->step 1 ${CateID}');
    print('-->step 1 ${Foodtype}');
    print('-->step 1 ${Start_date}');
    print('-->step 1 ${End_date}');
    // try {
    if (CateID != null ||
        Foodtype != null ||
        Start_date != null ||
        End_date != null) {
      _filteredContacts.clear();
      food.clear();
    }

    setState(() {
      if (currentPage == 0) {
        isLoading = true;
      } else {
        _isLoading = true;
      }
    });
    print('-->step 2');

    var url = '${Url}foods?limit=6&offset=$pagekey';
    var url2 =
        '${Url}foods?category_id=$CateID&food_type=$Foodtype&start_date=$Start_date&end_date=$End_date' /*&limit=6&offset=$pagekey'*/;
    setState(() {
      if (CateID == null ||
          Foodtype == null ||
          Start_date == null ||
          End_date == null) {
        print('----$url--');
        isfilter = 'alldata';
      } else {
        print('----$url2--');
        isfilter = 'filterdata';
      }
    });

    final response = await http.get(
      Uri.parse(CateID == null ||
              Foodtype == null ||
              Start_date == null ||
              End_date == null
          ? url
          : url2),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );

    print('-->step 3 ${storage.read('api_token_login')}');
    print('response------------>${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('-->step 4');
      setState(() {
        final data = json.decode(response.body);
        print('-->step 5');

        if (data['success'] == true) {
          print('-->step 6');
          // foodies.addAll();
          food.addAll(data['data']);
          _filteredContacts = food;
          // log('---- $_filteredContacts');

          if (currentPage == 0) {
            isLoading = false;
          } else {
            _isLoading = false;
          }

          // log('food ----------->${food[0]}');
          // print(food[0]['data'][0]);
        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
          setState(() {
            if (currentPage == 0) {
              isLoading = false;
            } else {
              _isLoading = false;
            }
          });
        }
      });
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      Navigator.of(context).pushReplacement(
        NoBlinkPageRoute(
          builder: (context) => const start_screen(),
        ),
      );
      storage.remove('email_verified');
      storage.remove('api_token_login');
    }
    /*  } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }*/
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            currentPage == 0
        ? !isLoading
        : !_isLoading) {
      currentPage += 6;
      foodlist(pagekey: currentPage);
    }
  }

  void deletefood(String id) async {
    print('-->step 1');
    // try {
    print('-->step 2');
    String url = '${Url}foods/$id';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        // Fluttertoast.showToast(msg: "Food is deleted successfully");
        Wid_Con.toastmsgg(
            context: context, msg: "Food is deleted successfully");
      }
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

  void _filterContacts(String text) {
    if (text.isEmpty) {
      setState(() {
        _filteredContacts = food;
      });
    } else {
      setState(() {
        _filteredContacts = food
            // .expand((day) => day)
            .where((item) => item["name"]
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()))
            .toList();
      });
      print(_filteredContacts);
    }
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
            NoBlinkPageRoute(builder: (context) => bottom_screen()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
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
              // titel: 'Eat At Home',
              // fontweight: FontWeight.w600,
              actions: [
                SizedBox(
                  width: 6.w,
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
                Navigator.push(
                    context,
                    NoBlinkPageRoute(
                        builder: (context) => ImageSelectionScreen()));
              },
              onPresprivacypolicy: () {
                Navigator.pop(context);
                Navigator.push(context,
                    NoBlinkPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
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
                Navigator.push(
                    context,
                    NoBlinkPageRoute(
                        builder: (context) => const ReviewSreen()));
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
              onPressedlogout: () {
                logout();
              }),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: controller,
                          cursorColor: grey,
                          onChanged: (value) {
                            setState(() {
                              _filterContacts(value);
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: white, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: white, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: grey200,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  color: grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins'),
                              prefixIcon: Icon(
                                Icons.search,
                                color: grey,
                                size: 17,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        filter_dialog_box();
                      },
                      child: Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment(0.5, 3),
                              colors: [
                                Color(0xFFE49630),
                                Color(0xFFC73C1B),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Image.asset('assets/images/list2.png',
                              height: 18),
                        ),
                      ),
                    ),

                    /*Wid_Con.button(
                      ButtonName: '',

                      height: 40,
                      width: 60,
                      ButtonRadius: 5,
                      child:Icon(Icons.filter)
                    ),*/
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading == true
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: blue),
                        ),
                      )
                    : _filteredContacts.isEmpty
                        ? Expanded(
                            child: Center(
                            child: Text(
                              'No Data!',
                              style: TextStyle(fontSize: 20, color: blue),
                            ),
                          ))
                        : Expanded(
                            child: isfilter == 'alldata'
                                ? GridView.builder(
                                    itemCount: _filteredContacts.length +
                                        (currentPage == 0
                                            ? isLoading
                                                ? 1
                                                : 0
                                            : _isLoading
                                                ? 1
                                                : 0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 3.0,
                                            mainAxisSpacing: 20.0,
                                            mainAxisExtent: 270),
                                    controller: _scrollController,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == _filteredContacts.length) {
                                        return Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                    color: orange),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16,
                                                      color: bluefont,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: fontfamily,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )));
                                      } else {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          elevation: 5,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.2),
                                          child: GestureDetector(
                                            onTap: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            onLongPress: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Delete Food?',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: greyfont,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              fontfamily),
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to delete this food item?',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: greyfont,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              fontfamily),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: Text('Cancel',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: red,
                                                            )),
                                                      ),
                                                      Wid_Con.button(
                                                        ButtonName: '',
                                                        onPressed: () {
                                                          deletefood(
                                                              _filteredContacts[
                                                                          index]
                                                                      ['id']
                                                                  .toString());
                                                          // Add your code here to delete the food item
                                                          // For example, you might call a function to delete the item from your data
                                                          // _deleteFoodItem(_filteredContacts[index]['id']);
                                                          _filteredContacts
                                                              .removeAt(
                                                                  index); // Remove the item from the list
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          setState(
                                                              () {}); // Trigger a rebuild to reflect the changes
                                                        },
                                                        height: 40,
                                                        width: 100,
                                                        ButtonRadius: 5,
                                                        child: Center(
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                _filteredContacts[index]
                                                            ['media']
                                                        .isNotEmpty
                                                    ? Expanded(
                                                        child: Container(
                                                          width: 100.w,
                                                          height: 20.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  '${_filteredContacts[index]['media'][0]['url']}'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: grey200,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                      ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _filteredContacts[index]
                                                            ['name'],
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 16,
                                                            color: bluefont,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                fontfamily),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "\u{20B9}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: greyfont,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 0.5.w,
                                                          ),
                                                          Text(
                                                            "${_filteredContacts[index]['price'].toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: greyfont,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    fontfamily),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      // const Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                NoBlinkPageRoute(
                                                                  builder: (context) =>
                                                                      addfood_screen(
                                                                          id: _filteredContacts[index]
                                                                          [
                                                                          'id']),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 35,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      gradient:
                                                                          const LinearGradient(
                                                                        begin: Alignment
                                                                            .topRight,
                                                                        end: Alignment(
                                                                            0.5,
                                                                            3),
                                                                        colors: [
                                                                          Color(
                                                                              0xFFE49630),
                                                                          Color(
                                                                              0xFFC73C1B),
                                                                        ],
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                              child:Center(
                                                                child: Image.asset(
                                                                    'assets/images/food_icon1.png',
                                                                    height: 15),
                                                              )
                                                            ),
                                                          ),
                                                         /* Wid_Con.button(
                                                            ButtonName: '',
                                                            onPressed: () {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                NoBlinkPageRoute(
                                                                  builder: (context) =>
                                                                      addfood_screen(
                                                                          id: _filteredContacts[index]
                                                                              [
                                                                              'id']),
                                                                ),
                                                              );
                                                            },
                                                            height: 35,
                                                            width: 50,
                                                            ButtonRadius: 3,
                                                            child: Center(
                                                              child: Image.asset(
                                                                  'assets/images/food_icon1.png',
                                                                  height: 15),
                                                            ),
                                                          ),*/
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              Navigator.of(
                                                                  context)
                                                                  .push(
                                                                NoBlinkPageRoute(
                                                                  builder: (context) => addfood_screen(
                                                                      id: _filteredContacts[
                                                                      index]
                                                                      [
                                                                      'id'],
                                                                      calander:
                                                                      true),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                                height: 35,
                                                                width: 50,
                                                                decoration:
                                                                BoxDecoration(
                                                                    gradient:
                                                                    const LinearGradient(
                                                                      begin: Alignment
                                                                          .topRight,
                                                                      end: Alignment(
                                                                          0.5,
                                                                          3),
                                                                      colors: [
                                                                        Color(
                                                                            0xFFE49630),
                                                                        Color(
                                                                            0xFFC73C1B),
                                                                      ],
                                                                    ),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        5)),
                                                                child:Center(
                                                                  child: Image.asset(
                                                                      'assets/images/food_icon2.png',
                                                                      height: 15),
                                                                )
                                                            ),
                                                          ),
                                                        /*  Wid_Con.button(
                                                            ButtonName: '',
                                                            onPressed: () {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                NoBlinkPageRoute(
                                                                  builder: (context) => addfood_screen(
                                                                      id: _filteredContacts[
                                                                              index]
                                                                          [
                                                                          'id'],
                                                                      calander:
                                                                          true),
                                                                ),
                                                              );
                                                            },
                                                            height: 35,
                                                            width: 50,
                                                            ButtonRadius: 3,
                                                            child: Center(
                                                              child: Image.asset(
                                                                  'assets/images/food_icon2.png',
                                                                  height: 15),
                                                            ),
                                                          ),*/
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    })
                                : GridView.builder(
                                    itemCount: _filteredContacts.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 3.0,
                                            mainAxisSpacing: 20.0,
                                            mainAxisExtent: 270),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                        shadowColor:
                                            Colors.grey.withOpacity(0.2),
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          onLongPress: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Delete Food?',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: greyfont,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: fontfamily),
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete this food item?',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: greyfont,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: fontfamily),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: red,
                                                          )),
                                                    ),
                                                    Wid_Con.button(
                                                      ButtonName: '',
                                                      onPressed: () {
                                                        deletefood(
                                                            _filteredContacts[
                                                                    index]['id']
                                                                .toString());
                                                        // Add your code here to delete the food item
                                                        // For example, you might call a function to delete the item from your data
                                                        // _deleteFoodItem(_filteredContacts[index]['id']);
                                                        _filteredContacts.removeAt(
                                                            index); // Remove the item from the list
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        setState(
                                                            () {}); // Trigger a rebuild to reflect the changes
                                                      },
                                                      height: 40,
                                                      width: 100,
                                                      ButtonRadius: 5,
                                                      child: Center(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              _filteredContacts[index]['media']
                                                      .isNotEmpty
                                                  ? Expanded(
                                                      child: Container(
                                                        width: 100.w,
                                                        height: 20.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                '${_filteredContacts[index]['media'][0]['url']}'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color: grey200,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                    ),
                                              Container(
                                                height: 14.h,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _filteredContacts[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 16,
                                                          color: bluefont,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              fontfamily),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "\u{20B9}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: greyfont,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 0.5.w,
                                                        ),
                                                        Text(
                                                          "${_filteredContacts[index]['price'].toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: greyfont,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  fontfamily),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    // const Spacer(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Wid_Con.button(
                                                          ButtonName: '',
                                                          onPressed: () {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              NoBlinkPageRoute(
                                                                builder: (context) =>
                                                                    addfood_screen(
                                                                        id: _filteredContacts[index]
                                                                            [
                                                                            'id']),
                                                              ),
                                                            );
                                                          },
                                                          height: 35,
                                                          width: 50,
                                                          ButtonRadius: 3,
                                                          child: Center(
                                                            child: Image.asset(
                                                                'assets/images/food_icon1.png',
                                                                height: 15),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Wid_Con.button(
                                                          ButtonName: '',
                                                          onPressed: () {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              NoBlinkPageRoute(
                                                                builder: (context) => addfood_screen(
                                                                    id: _filteredContacts[
                                                                            index]
                                                                        ['id'],
                                                                    calander:
                                                                        true),
                                                              ),
                                                            );
                                                          },
                                                          height: 35,
                                                          width: 50,
                                                          ButtonRadius: 3,
                                                          child: Center(
                                                            child: Image.asset(
                                                                'assets/images/food_icon2.png',
                                                                height: 15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  String selectedCategory = 'Select Category'; // Default category
  var selectedCategoryID; // Default category

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
          _startDate = pickedDate;
          _startDateController.text =
              "${_startDate!.toLocal().toString().split(' ')[0]}";
        } else {
          _endDate = pickedDate;
          _endDateController.text =
              "${_endDate!.toLocal().toString().split(' ')[0]}";
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
            titlePadding:
                EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Food'),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close))
              ],
            ),
            actions: <Widget>[
              Container(
                height: 250,
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
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
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
                      hint: const Text("Selected Category"),
                      iconSize: 30,
                      iconEnabledColor: Colors.black,
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 15,
                      ),
                      value: selectedCategory,
                      items: <String>[
                        'Select Category',
                        'All',
                        'Breakfast',
                        'Lunch',
                        'Snacks',
                        'Dinner'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                          if (selectedCategory == 'Breakfast') {
                            selectedCategoryID = 8;
                          } else if (selectedCategory == 'Lunch') {
                            selectedCategoryID = 9;
                          } else if (selectedCategory == 'Snacks') {
                            selectedCategoryID = 7;
                          } else if (selectedCategory == 'Dinner') {
                            selectedCategoryID = 10;
                          } else if (selectedCategory == 'All') {
                            selectedCategoryID = 21;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Choose Date for food",
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
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(context, true),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                  labelText: 'End Date',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () =>
                                        _selectDate(context, false),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Select Food Type",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selected_range == '3') {
                                      selected_range = 0.toString();
                                    } else {
                                      selected_range = 3.toString();
                                    }
                                    print('------type----> $selected_range');
                                  });
                                },
                                child: Container(
                                  // width: 70,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selected_range == '3' ? 0 : 1),
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: selected_range == '3'
                                          ? const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment(0.5, 3),
                                              colors: [
                                                Color(0xFFE49630),
                                                Color(0xFFC73C1B),
                                              ],
                                            )
                                          : null),
                                  child: Center(
                                      child: Text(
                                    "All",
                                    style: TextStyle(
                                        color: selected_range == '3'
                                            ? Colors.white
                                            : Colors.black),
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selected_range == '1') {
                                      selected_range = 0.toString();
                                    } else {
                                      selected_range = 1.toString();
                                    }
                                    print('------type----> $selected_range');
                                  });
                                },
                                child: Container(
                                  // width: 70,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selected_range == '1' ? 0 : 1),
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: selected_range == '1'
                                          ? const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment(0.5, 3),
                                              colors: [
                                                Color(0xFFE49630),
                                                Color(0xFFC73C1B),
                                              ],
                                            )
                                          : null),
                                  child: Center(
                                      child: Text("Dine-in",
                                          style: TextStyle(
                                              color: selected_range == '1'
                                                  ? Colors.white
                                                  : Colors.black))),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selected_range == '2') {
                                      selected_range = 0.toString();
                                    } else {
                                      selected_range = 2.toString();
                                    }
                                    print('------type----> $selected_range');
                                  });
                                },
                                child: Container(
                                  // width: 70,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selected_range == '2' ? 0 : 1),
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: selected_range == '2'
                                          ? const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment(0.5, 3),
                                              colors: [
                                                Color(0xFFE49630),
                                                Color(0xFFC73C1B),
                                              ],
                                            )
                                          : null),
                                  child: Center(
                                      child: Text("Delivery",
                                          style: TextStyle(
                                              color: selected_range == '2'
                                                  ? Colors.white
                                                  : Colors.black))),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
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
                  foodlist(
                      CateID: selectedCategoryID ?? '',
                      Foodtype: selected_range ?? '',
                      Start_date: _startDateController.text ?? '',
                      End_date: _endDateController.text ?? '');
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

  List<DateTime> parseDates(String datesString) {
    // print('-------------> $datesString');
    List<String> dateStrings = datesString.split(',');
    print(dateStrings.length);
    return dateStrings.map((dateStr) {
      // Split the date string into day, month, and year
      List<String> dateParts = dateStr.split('-');
      // Parse each part and create a DateTime object
      return DateTime(
        int.parse(dateParts[2]), // Year
        int.parse(dateParts[1]), // Month
        int.parse(dateParts[0]), // Day
      );
    }).toList();
  }

  void reloadListData() {
    // Add the code to reload the data or setState to rebuild the widget
    // For example, if _filteredContacts is a state variable, you can call:
    setState(() {
      // Code to refresh the data
    });
  }
}
