import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../Constants/App_Colors.dart'; // Import intl package for date formatting

class PayoutHistoryPage extends StatefulWidget {
  @override
  _PayoutHistoryPageState createState() => _PayoutHistoryPageState();
}

class _PayoutHistoryPageState extends State<PayoutHistoryPage> {
  List<Map<String, dynamic>> payoutHistory = [];

  @override
  void initState() {
    super.initState();
    fetchPayoutHistory();
  }

  Future<void> fetchPayoutHistory() async {
    String apiUrl = 'https://eatathome.in/app/api/kitchen/payout-histroy';

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            payoutHistory = List<Map<String, dynamic>>.from(responseData['data']);
          });
        }
      }
    } catch (e) {
      print('Error fetching payout history: $e');
    }
  }
  Color getStatusColor(String status) {
    switch (status) {
      case '0':
        return Colors.lightBlue; // Pending
      case '1':
        return Colors.green; // Paid
      case '2':
        return Colors.red;
        case '3':
        return Colors.blue;
        case '4':
        return Colors.orange;
      case '5':
        return Colors.red; // On Hold
      default:
        return blue; // Default to pending
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case '0':
        return 'Pending';
      case '1':
        return 'Accept';
      case '2':
        return 'Declined';
      case '3':
        return 'Paid';
      case '4':
        return 'Requested';
      case '5':
        return 'Failed';

      default:
        return 'Pending';
    }
  }

  String getActionStatusText(String status) {
    switch (status) {
      case '0':
        return 'Pending';
      case '1':
        return 'Accept';
      case '2':
        return 'Decline';
      default:
        return 'Pending';
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(

        backgroundColor:  Colors.grey.shade200,
        appBar: AppBar(
         backgroundColor: trans,
          elevation: 0,
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Text("Payout History",  style: TextStyle(
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Poppins',
            color: red,
          ) ),
          //title: Text('Payout History'),
        ),
        body: payoutHistory.isEmpty
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
          itemCount: payoutHistory.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> payout = payoutHistory[index];
            // Format date in dd-mm-yyyy format
            String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(payout['paid_date']));
            return Container(

              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payout ID #${payout['id']}',style: TextStyle(
                              fontFamily: fontfamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: blue)),

                          payout['action_status'] == "3" && payout['method'] == "Bank" ?

                          Row(
                            children: [
                              Text(getStatusText(payout['action_status']), style: TextStyle(
                                fontFamily: fontfamily,
                                fontWeight: FontWeight.w500,
                                //fontSize: 16,
                                color: getStatusColor(payout['action_status']),)),
                              Text(" #${payout['cf_transfer_id'].toString()}",style: TextStyle(
                                  fontFamily: fontfamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: blue)),
                            ],
                          ) :Text(getStatusText(payout['action_status']), style: TextStyle(
                            fontFamily: fontfamily,
                            fontWeight: FontWeight.w500,
                          //  fontSize: 16,
                            color: getStatusColor(payout['action_status']),))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Type',style: TextStyle(
                              fontFamily: fontfamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: blue)),
                          Text('${payout['method'] ?? ''}',style: TextStyle(
                              fontFamily: fontfamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: blue)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Amount',style: TextStyle(
                      fontFamily: fontfamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: blue)),
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
                              Text('${payout['amount']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: blue,

                                      fontFamily: fontfamily)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payout Date',style: TextStyle(
            fontFamily: fontfamily,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: blue)),
                          Text('$formattedDate',style: TextStyle(
            fontFamily: fontfamily,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: blue)),
                        ],
                      ), // Display format
                      // ted date
                      SizedBox(height: 8),
                   //  if(payout['method'] ==  "Bank")
                     /* Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Transaction ID',style: TextStyle(
                              fontFamily: fontfamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: blue)),
                          Text(payout['cf_transfer_id'].toString(),style: TextStyle(
                              fontFamily: fontfamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: blue)),
                        ],
                      ),*/
                      //Text('Payment Status: ${payout['payment_status'] ?? ''}'),

                      //Text('Action Status: ${payout['action_status'] ?? ''}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
