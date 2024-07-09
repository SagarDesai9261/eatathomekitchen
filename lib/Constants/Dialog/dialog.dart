import 'package:comeeathome/Constants/Widget.dart';
import 'package:flutter/material.dart';

import '../../../Constants/App_Colors.dart';

class dialog extends StatefulWidget {
  final List options;
  final String selectedOption;
  final void Function(String) onOptionSelected;

  dialog({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  _dialogState createState() => _dialogState();
}

class _dialogState extends State<dialog> {
  String _selectedOption = '';

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
                  Column(
                    children: List<Widget>.generate(
                      widget.options[0].length,
                      (int index) {
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: RadioListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            title: Text(
                                widget.options[0][index]['name'].toString()),
                            activeColor: orange,
                            controlAffinity: ListTileControlAffinity.leading,
                            visualDensity: VisualDensity.compact,
                            value: widget.options[0][index]['name'].toString(),
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                                print('---------food------> $value');

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
