// import 'package:comeeathome/Constants/Widget.dart';
// import 'package:flutter/material.dart';
//
// import '../../../Constants/App_Colors.dart';
//
// class cuisineDialog extends StatefulWidget {
//   final List options;
//   final String selectedOption;
//   final void Function(String) onOptionSelected;
//
//   cuisineDialog({
//     required this.options,
//     required this.selectedOption,
//     required this.onOptionSelected,
//   });
//
//   @override
//   _cuisineDialogState createState() => _cuisineDialogState();
// }
//
// class _cuisineDialogState extends State<cuisineDialog> {
//   String _selectedOption = '';
//
//   @override
//   void initState() {
//     _selectedOption = widget.selectedOption;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       titlePadding: EdgeInsets.zero,
//       title: Container(
//         padding: EdgeInsets.zero,
//         height: 300,
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(
//                     height: 30,
//                     width: double.infinity,
//                     child: Center(
//                       child: Text(
//                         'Cuisine',
//                         style: TextStyle(fontSize: 20, color: black),
//                       ),
//                     ),
//                   ),
//                   Divider(color: grey, thickness: 0.5),
//                   Column(
//                     children: List<Widget>.generate(
//                       widget.options.length,
//                           (int index) {
//                         return Padding(
//                           padding: EdgeInsets.zero,
//                           child: RadioListTile(
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 0, horizontal: 0),
//                             title: Text(widget.options[index].toString()),
//                             activeColor: orange,
//                             controlAffinity: ListTileControlAffinity.leading,
//                             visualDensity: VisualDensity.compact,
//                             value: widget.options[index].toString(),
//                             groupValue: _selectedOption,
//                             onChanged: ( value) {
//                               setState(() {
//                                 _selectedOption = value!;
//                                 widget.onOptionSelected(value);
//                               }); // Close the dialog
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 40,),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Wid_Con.button(ButtonName: 'CANCLE', onPressed: (){Navigator.of(context).pop();},ButtonRadius: 0,titelcolor: white,fontSize: 20,fontWeight: FontWeight.w500),
//                   ),
//                   Expanded(
//                     child: Wid_Con.button(ButtonName: 'OK', onPressed: (){Navigator.of(context).pop();},ButtonRadius: 0,titelcolor: white,fontSize: 20,fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:comeeathome/Constants/Widget.dart';
import 'package:flutter/material.dart';

import '../../Constants/App_Colors.dart';


class certificateDialog extends StatefulWidget {
  final List selectCts;
  final titel;
  final List<String> selectedCts;
  final List<int> selectCertificate;
  final Function(List<String>) onSelectedCtsChanged;
  final Function(List<int>) onSelectedCertiChanged;
  const certificateDialog(
      {Key? key,
        required this.selectCts,
        required this.selectedCts,
        required this.onSelectedCtsChanged,
        required this.selectCertificate,
        required this.onSelectedCertiChanged,
        required this.titel})
      : super(key: key);

  @override
  State<certificateDialog> createState() => _certificateDialogState();
}

class _certificateDialogState extends State<certificateDialog> {
  late List<String> _currentSelectedCts;
  late List<int> selectedCerti;

  @override
  void initState() {
    super.initState();
    _currentSelectedCts = List.from(widget.selectedCts);
    selectedCerti = List.from(widget.selectCertificate);
  }

  void _handleCancelButtonPressed() {
    Navigator.of(context).pop();
  }

  void _handleOkButtonPressed() {
    widget.onSelectedCtsChanged(_currentSelectedCts);
    widget.onSelectedCertiChanged(selectedCerti); // Pass selectedCerti back
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: EdgeInsets.zero,
        height: 360,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                   widget.titel?? '',
                    style: TextStyle(fontSize: 20, color: black),
                  ),
                ),
              ),
            ),
            Divider(color: grey, thickness: 0.5),
            Container(
              height: 256,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: widget.selectCts.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    activeColor: orange,
                    visualDensity: VisualDensity.compact,
                    title: Text(widget.selectCts[index]['name']),
                    value: _currentSelectedCts
                        .contains(widget.selectCts[index]['name']),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          _currentSelectedCts
                              .add(widget.selectCts[index]['name']);
                          selectedCerti.add(widget.selectCts[index]['id']);
                        } else {
                          _currentSelectedCts
                              .remove(widget.selectCts[index]['name']);
                          selectedCerti
                              .remove(widget.selectCts[index]['id']);
                        }
                        print('-----_currentSelected--> $_currentSelectedCts');
                        print('-----_currentSelected--> $selectedCerti');

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
                      ButtonName: 'Cancel',
                      onPressed: _handleCancelButtonPressed,
                      ButtonRadius: 0,
                      titelcolor: white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Wid_Con.button(
                      ButtonName: 'Ok',
                      onPressed: _handleOkButtonPressed,
                      ButtonRadius: 0,
                      titelcolor: white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
//
// class adddiscount extends StatefulWidget {
//   const adddiscount({Key? key}) : super(key: key);
//
//   @override
//   State<adddiscount> createState() => _adddiscountState();
// }
//
// class _adddiscountState extends State<adddiscount> {
//   List<String> adoption = ["Fixed","Percent"];
//   TextEditingController adoptionn = TextEditingController();
//   TextEditingController adoptionn2 = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       titlePadding: EdgeInsets.zero,
//       title: Container(
//         padding: EdgeInsets.zero,
//         height: 254,
//         child: Column(
//           children: [
//             SizedBox(height: 10,),
//             SizedBox(
//               height: 40,
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Center(
//                   child: Text(
//                     'Add Discount',
//                     style: TextStyle(fontSize: 20, color: black),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20,),
//             // Divider(color: grey, thickness: 0.5),
//             Padding(
//               padding: const EdgeInsets.only(left: 5,right: 5),
//               child: Container(
//                 height: 60,
//                 width: double.maxFinite,
//                 child:CustomDropdown(
//                   borderRadius: BorderRadius.circular(4),
//                   borderSide: BorderSide(color: grey300),
//                   hintText: "Select Type",
//                   selectedStyle: TextStyle(
//                       fontSize: 13, color: grey),
//                   hintStyle: TextStyle(
//                       fontSize: 13, color: grey),
//                   items: adoption,
//                   controller: adoptionn,
//                   onChanged: (value) {
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 5,right: 5),
//               child: Container(
//                 height: 45,
//                 child: TextFormField(
//                   style: TextStyle(
//                     color: grey,
//                     fontSize: 15,
//                     fontFamily: fontfamily,
//                   ),
//                   controller: adoptionn2,keyboardType: TextInputType.number,
//                   cursorColor: grey,
//                   decoration: InputDecoration(
//                     isDense: true,
//                     // hintText: 'Insert Pin code',
//                     hintStyle: TextStyle(
//                       color: grey,
//                       fontSize: 13,
//                       fontFamily: fontfamily,
//                     ),
//                     contentPadding:
//                     const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 15),
//                     focusedBorder: OutlineInputBorder(
//                         borderRadius:
//                         BorderRadius.circular(5),
//                         borderSide: BorderSide(
//                             color: grey300, width: 1)),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(
//                           color: grey300, width: 1),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 25,),
//             Padding(
//               padding: const EdgeInsets.only(left: 3,right: 3),
//               child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: Wid_Con.button(
//                         ButtonName: 'Cancel',
//                         onPressed: (){
//                           Navigator.of(context).pop();
//                         },
//                         ButtonRadius: 0,
//                         titelcolor: white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   Expanded(
//                     child: Wid_Con.button(
//                         ButtonName: 'Submit',
//                         onPressed: (){},
//                         ButtonRadius: 0,
//                         titelcolor: white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5,),
//           ],
//         ),
//       ),
//     );
//   }
// }

