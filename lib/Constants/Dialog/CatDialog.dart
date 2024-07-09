import 'package:comeeathome/Constants/Widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../Constants/App_Colors.dart';

class CatDialog extends StatefulWidget {
  final List options;
  final String selectedOption;
  final void Function(String) onOptionSelected;
  final void Function(String) onOptionSelectedID;

  CatDialog({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.onOptionSelectedID,
  });

  @override
  _CatDialogState createState() => _CatDialogState();
}

class _CatDialogState extends State<CatDialog> {
  String _selectedOption = '';
  String _selectedOptionID = '';
  var datasp;
  Map<String,dynamic>? mapdata;

  @override
  void initState() {
    _selectedOption = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: EdgeInsets.zero,
        height: 300,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Category',
                        style: TextStyle(fontSize: 20, color: black),
                      ),
                    ),
                  ),
                  Divider(color: grey, thickness: 0.5),
                  Column(
                    children: List<Widget>.generate(
                      widget.options.length,
                      (int index) {
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: RadioListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            title: Text(
                                widget.options[index]['name'].toString()),
                            activeColor: orange,
                            controlAffinity: ListTileControlAffinity.leading,
                            visualDensity: VisualDensity.compact,
                            value: widget.options[index]['name'].toString(),
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                                _selectedOptionID = widget.options[index]['id'].toString();
                                // print('-----> ${widget.options[0][index]['id']}');

                              }); // Close the dialog
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Wid_Con.button(
                        ButtonName: 'CANCLE',
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
                          widget.onOptionSelected(_selectedOption);
widget.onOptionSelectedID(_selectedOptionID);
                          Navigator.of(context).pop();
                        },
                        ButtonRadius: 0,
                        titelcolor: white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
