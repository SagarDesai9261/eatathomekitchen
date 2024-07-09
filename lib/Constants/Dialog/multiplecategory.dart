import 'package:flutter/material.dart';

import '../../Constants/App_Colors.dart';
import '../Widget.dart';

class multiCatDialog extends StatefulWidget {
  final List selectCts;
  final List<String> selectedCts;
  final List<String> selectedCtsID;
  final Function(List<String>) onSelectedCtsChanged;
  final Function(List<String>) onSelectedCtsChangedID;

  const multiCatDialog({
    Key? key, // Add Key parameter
    required this.selectCts,
    required this.selectedCts,
    required this.selectedCtsID,
    required this.onSelectedCtsChanged,
    required this.onSelectedCtsChangedID,
  }) : super(key: key);

  @override
  _multiCatDialogState createState() => _multiCatDialogState();
}

class _multiCatDialogState extends State<multiCatDialog> {
   List<String> _currentSelectedCts = [];
   List<String> _currentSelectedCtsID = [];


  @override
  void initState() {
    super.initState();
    _currentSelectedCts = List.from(widget.selectedCts);
    _currentSelectedCtsID = List.from(widget.selectedCtsID);
  }

  void _handleCancelButtonPressed() {
    Navigator.of(context).pop();
  }

  void _handleOkButtonPressed() {
    widget.onSelectedCtsChanged(_currentSelectedCts);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SimpleDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
        title: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Select Category',
                  style: TextStyle(fontSize: 20, color: black),
                ),
              ),
            ),
            Divider(color: grey, thickness: 0.5),
          ],
        ),
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(8.0), // Adjust the radius as needed
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 252,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: widget.selectCts.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          activeColor: Color(0xFFE49630),
                          visualDensity: VisualDensity.compact,
                          title: Text(widget.selectCts[index]['name_time']),
                          value: _currentSelectedCts
                              .contains(widget.selectCts[index]['name_time']),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _currentSelectedCts
                                    .add(widget.selectCts[index]['name_time']);
                                _currentSelectedCtsID.add(widget.selectCts[index]['id'].toString());
                              } else {
                                _currentSelectedCts
                                    .remove(widget.selectCts[index]['name_time']);
                                _currentSelectedCtsID.remove(widget.selectCts[index]['id'].toString());
                              }
                              // print('-----------------Cat-----> $_currentSelectedCts');
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Wid_Con.button(
                            ButtonName: 'CANCEL',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            ButtonRadius: 0,
                            titelcolor: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Wid_Con.button(
                            ButtonName: 'OK',
                            onPressed: () {
                              // print('-----------ok-----------> $_currentSelectedCts');
                              widget.onSelectedCtsChanged(_currentSelectedCts);
                              widget.onSelectedCtsChangedID(_currentSelectedCtsID);
                              Navigator.of(context).pop();
                            },
                            ButtonRadius: 0,
                            titelcolor: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
