import 'dart:convert';
import 'dart:developer';
import 'package:comeeathome/Pages/screens/Food_Screen/addfood_screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payoutDetails_screen.dart';
import 'package:comeeathome/Pages/screens/Payout_Screen/payout_screen.dart';
import 'package:comeeathome/Pages/screens/Profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/App_Colors.dart';
import '../../../Constants/Custum_bottombar/Bottombar.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import '../../../model/model.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../Service/Privacy_policy.dart';
import '../bottombar_screen.dart';

class ReviewSreen extends StatefulWidget {
  const ReviewSreen({Key? key}) : super(key: key);

  @override
  State<ReviewSreen> createState() => _ReviewSreenState();
}

class _ReviewSreenState extends State<ReviewSreen> {
  DataModel? dataModel;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isVisible = true;
  List Userreview = [];
  List ReviewDate = [];
  List Counter = [];

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

  void UserReview() async {
    setState(() {
      isLoading = true;
    });
    try {
      print('---->step 2 ${storage.read('api_token_login')}');

      const url = '${Url}reviews';

      final response = await http.get(
        Uri.parse('https://eatathome.in/app/api/kitchen/reviews'),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );
      print('----response-> ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          print(data['data']);
          setState(() {
            Map<String, dynamic> parsedJson = data;

            dataModel = DataModel.fromJson(parsedJson['data']);
            print(dataModel!.counter);
            print(dataModel!.reviews[0].review);

            log('-----review---> $ReviewDate');
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
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) => const start_screen(),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserReview();
  }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) => bottom_screen()))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    //print();
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
            titel: 'KITCHEN REVIEW',
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
              setState(() {
                isVisible = !isVisible;
              });
            }),
        bottomNavigationBar: const Bottombar(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            :
        dataModel!.reviews.length ==0 ? Center(child: Text("No review Found")) :

        Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Overall Rating"),
                    ),
                    Row(
                      children: [
                        Text(
                          "${dataModel!.counter["average"]}",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w900),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating: (dataModel!
                                                .counter["counterFiveStars"] *
                                            5 +
                                        dataModel!.counter["counterFourStars"] *
                                            4 +
                                        dataModel!
                                                .counter["counterThreeStars"] *
                                            3 +
                                        dataModel!.counter["counterTwoStars"] *
                                            2 +
                                        dataModel!.counter["counterOneStars"] *
                                            1) /
                                    dataModel!.counter["counter"],
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemSize: 30,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 10,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "based on ${dataModel!.counter["counter"]} reviews",
                                    style: TextStyle(color: Colors.grey),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          //color: grey300,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: RatingSummary(
                          counter: dataModel!.counter["counter"],
                          average:
                              5, // (dataModel!.counter["counterFiveStars"] * 5 + dataModel!.counter["counterFourStars"] * 4 + dataModel!.counter["counterThreeStars"] * 3 + dataModel!.counter["counterTwoStars"] *2 + dataModel!.counter["counterOneStars"] *1) /dataModel!.counter["counter"],
                          showAverage: false,
                          counterFiveStars:
                              dataModel!.counter["counterFiveStars"],
                          counterFourStars:
                              dataModel!.counter["counterFourStars"],
                          counterThreeStars:
                              dataModel!.counter["counterThreeStars"],
                          counterTwoStars:
                              dataModel!.counter["counterTwoStars"],
                          counterOneStars:
                              dataModel!.counter["counterOneStars"],
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User Reviews',
                          style: TextStyle(
                              fontFamily: fontfamily,
                              fontSize: 14,
                              color: bluefont,
                              fontWeight: FontWeight.w400),
                        ),
                        Visibility(
                          visible: false,
                          child: Row(
                            children: [
                              Text(
                                'Most Useful',
                                style: TextStyle(
                                    fontFamily: fontfamily,
                                    fontSize: 14,
                                    color: bluefont,
                                    fontWeight: FontWeight.w400),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: bluefont,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                        child: ListView.builder(
                      itemCount: dataModel!.reviews.length,
                      itemBuilder: (context, i) {
                        Review review = dataModel!.reviews[i];

                        return Column(
                          children: [
                            ListTile(
                              leading:review.user.media.isEmpty ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/prifile.png',),scale:3.0)),
                              ) :Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                        image:NetworkImage(
                                          dataModel!.reviews[i].user.media[0].url,
                                          scale: 6

                                        )

                                    )),
                              ) ,
                              title: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  '${review.user.name}',
                                  style: TextStyle(
                                      fontFamily: fontfamily,
                                      fontSize: 14,
                                      color: bluefont,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBar.builder(
                                    initialRating: double.parse(review.rate),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1.0,vertical: 3),
                                    itemSize: 18,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 10,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),

                                  if(review.review != "")
                                  Padding(
                                    padding:EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      "${review.review}",
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 14,
                                          color: grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0,vertical: 2),
                                    child: Text(
                                      '${formateddate(review.createdAt)}',
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 12,
                                          color: grey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Divider()
                          ],
                        );
                        /*   return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: grey300,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15,left: 20,right: 20,bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                 Container(
                                   height: 30,
                                   width: 30,
                                   decoration: BoxDecoration(
                                     color: black,
                                     borderRadius: BorderRadius.circular(50),
                                     image: DecorationImage(image: AssetImage('assets/images/prifile.png'))
                                   ),
                                 ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    child: Text(
                                      '${review.user.name}',
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 14,
                                          color: bluefont,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    '${formateddate(review.createdAt)}',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 12,
                                        color: grey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              if(review.review != "")
                              Padding(
                                padding: const EdgeInsets.only(top: 15,bottom: 15),
                                child: Text(
                                  "${review.review}",
                                  style: TextStyle(
                                      fontFamily: fontfamily,
                                      fontSize: 14,
                                      color: grey,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                        RatingBar.builder(
                          initialRating: double.parse(review.rate),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 10,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                            ],
                          ),
                        ),
                      ),
                    );*/
                      },
                    ))
                  ],
                ),
              ),
      ),
    );
  }

  String formateddate(String date) {
    DateTime formated = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(formated).toString();
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
