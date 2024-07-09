import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Constants/App_Colors.dart';
import '../../../Constants/Custum_bottombar/Bottombar.dart';
import '../../../Constants/Dialog/CatDialog.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Dialog/multiplecategory.dart';
import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Payout_Screen/Addcard_screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Payout_Screen/payoutDetails_screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Login_Screen/Start_Screen.dart';
import '../Profile_Screen/profile_screen.dart';
import '../Service/Privacy_policy.dart';

class ExtraItemsModel {
  String name;
  String price;
  String images;

  ExtraItemsModel(
      {required this.name, required this.images, required this.price});
}

class _ExtraItems extends StatefulWidget {
  const _ExtraItems({Key? key, required this.extraItemsModel, required this.onRemove})
      : super(key: key);

  final ExtraItemsModel extraItemsModel;
  final VoidCallback onRemove;

  @override
  State<_ExtraItems> createState() => _ExtraItemsState();
}

class _ExtraItemsState extends State<_ExtraItems> {
  late final foodnameINDController = TextEditingController(text: widget.extraItemsModel.name);
  late final foodpriceINDController = TextEditingController(text: widget.extraItemsModel.price);
  bool isBigImageINDI = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name*',
                    style: TextStyle(
                      fontFamily: fontfamily,
                      fontSize: 14,
                      color: bluefont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      style: TextStyle(
                        color: grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Poppins',
                      ),
                      controller: foodnameINDController,
                      onChanged: (value) {
                        widget.extraItemsModel.name = value;
                      },
                      cursorColor: grey,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: grey300, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: grey300, width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        hintStyle: TextStyle(
                          color: grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          fontFamily: fontfamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      fontFamily: fontfamily,
                      fontSize: 14,
                      color: bluefont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      style: TextStyle(
                        color: grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Poppins',
                      ),
                      controller: foodpriceINDController,
                      onChanged: (value) {
                        widget.extraItemsModel.price = value;
                      },
                      cursorColor: grey,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: grey300, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: grey300, width: 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        hintStyle: TextStyle(
                          color: grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          'Image*',
          style: TextStyle(
            fontFamily: fontfamily,
            fontSize: 14,
            color: bluefont,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: grey300, width: 0.7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: widget.extraItemsModel.images.isNotEmpty
                    ? widget.extraItemsModel.images.contains('https')
                    ? Image.network(widget.extraItemsModel.images, fit: BoxFit.fitHeight)
                    : Image.file(File(widget.extraItemsModel.images), fit: BoxFit.fitHeight)
                    : Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Image.asset(
                          'assets/images/gallery.png',
                          height: 50,
                        ),
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final picker = ImagePicker();
                          XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
                          final bytes = (await pickedImage?.readAsBytes())?.lengthInBytes;
                          setState(() {});
                          final kb = bytes! / 1024;

                            if (10000 > kb) {
                              final croppedFile = await ImageCropper().cropImage(sourcePath: pickedImage!.path, compressFormat: ImageCompressFormat.jpg, compressQuality: 100,
                                aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                                uiSettings: [ IOSUiSettings(title: ''),AndroidUiSettings(toolbarTitle: '',toolbarColor: Colors.black, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: true),],);

                              if (croppedFile != null) {
                                setState(() {
                                  widget.extraItemsModel.images = croppedFile.path;
                                });
                              }
                             // widget.extraItemsModel.images = pickedImage!.path;
                              isBigImageINDI = false;
                              print("------------Size Down ------> ${kb}");
                            } else {
                              isBigImageINDI = true;
                              print("------------Image size Up ------> ${kb}");
                            }

                        },
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Select File',
                        style: TextStyle(
                          fontFamily: fontfamily,
                          fontSize: 11,
                          color: greyfont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Wid_Con.showAlertDialog(
                        message: 'Are you sure want to Delete?',
                        onPressed_no: (){
                          Navigator.pop(context);
                        },
                        onPressed_yes: () async {
                          removeItem();
                          Navigator.pop(context);
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
        ),
        isBigImageINDI == true
            ? Text(
          'Please select images smaller than 10 MB',
          style: TextStyle(
            fontFamily: fontfamily,
            fontSize: 11,
            color: red,
          ),
        )
            : Container(),
        const SizedBox(height: 20),
      ],
    );
  }

  // Function to remove the item
  void removeItem() {
    // You can use a callback function to notify the parent widget to remove the item
    widget.extraItemsModel.images = ''; // Clear the image path or perform any necessary cleanup
    widget.onRemove(); // Notify the parent widget to remove this item
  }
}

class addfood_screen extends StatefulWidget {
  final id;
  final calander;

  const addfood_screen({Key? key, this.id, this.calander}) : super(key: key);

  @override
  State<addfood_screen> createState() => _addfood_screenState();
}

class _addfood_screenState extends State<addfood_screen> {
  ///[descriptionController] create a QuillEditorController to access the editor methods
  TextEditingController descriptionController = TextEditingController();
  // QuillEditorController descriptionController = QuillEditorController();

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    // ToolBarStyle.bold,
    // ToolBarStyle.italic,
    // ToolBarStyle.align,
    // ToolBarStyle.color,
    // // ToolBarStyle.background,
    // ToolBarStyle.listBullet,
    // ToolBarStyle.listOrdered,
    // ToolBarStyle.clean,
  ];

  bool _hasFocus = false;
  List<DateTime> dates = [];
  TextEditingController descontroller = TextEditingController();
  Map<String, int> categoryIDs = {
    'Breakfast': 7,
    'Lunch': 8,
    'Snacks': 9,
    'Dinner': 10,
  };

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  DateRangePickerController DatesController = DateRangePickerController();
  List<String> DatesOfCal = [];
  bool? isDate;

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

  bool isChecked = false;
  bool isChecked2 = false;
  bool isLoading = true;

  var foodpriceIND = <TextEditingController>[];
  var foodnameIND = <TextEditingController>[];

  List FoodDetails = [];
  int? selectedValue;
  String? SelecteValue;
  var data;
  var Description;
  TimeOfDay? fromselectedTime;
  TimeOfDay? toselectedTime;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController =  ScrollController();
  TextEditingController addmemberController = TextEditingController();
  TextEditingController discountcontroller = TextEditingController();
  TextEditingController price2controller = TextEditingController();
  TextEditingController priceSeparateController = TextEditingController();
  TextEditingController standardController = TextEditingController();
  List FoodName = [];
  List FoodNameIndividual = [];
  List FoodNameCategory = [];
  List<String> foodname = [];
  List<String> foodnameIndividual = [];
  List<Widget> IndiItem = [];
  File? _image;
  String editimage = '';
  File? image;
  TextEditingController foodName = TextEditingController();
  TextEditingController cuisines = TextEditingController();
  List<Map<String, dynamic>> individualDetails = [];
  List<XFile>? _selectedImages = [];
  List<XFile>? ThumbImages = [];
  bool signaturefood = false;

  // This is the image picker
  final _picker = ImagePicker();
  final picker = ImagePicker();

  bool isBigImage = false;

  List<ExtraItemsModel> extraItems = [];

  List<String> cuisine = [];

  List cuisinesData = [];
  List<String> selectedCertificateValue = [];

  var indiName = TextEditingController();
  var indiprice = TextEditingController();

  Future<void> cuisineList({int? cuisinesID}) async {
    cuisine.clear();
    setState(() {
      // isLoading = true;
    });
    try {
      const url = 'https://eatathome.in/app/api/cuisines';
      final response = await http.get(
        Uri.parse(url),
      );
      final data = json.decode(response.body);

      if(response.statusCode==200||response.statusCode==201) {
        if (data['success'] == true) {
          setState(() {
            cuisinesData.addAll(data['data']);
            data['data'].forEach((e) {
              cuisine.add(e['name']);
            });
            if(cuisinesID != null){
              for (var food in cuisinesData) {
                if (food['id'] == cuisinesID) {
                  setState(() {
                    cuisines.text = food['name'];

                    selecteOptionID = food['id'];
                    print('--------cuisine------> $cuisineselecteOption');
                    print('--------cuisine------> $selecteOptionID');

                  });
                  break; // Exit the loop once you find the matching food
                }
              }
            }
          });
          setState(() {
            // isLoading = false;
          });
          // log('-----cuisine--------> ${cuisinesData}');
        } else {
          String errorMessage = data['message'];
          print('error :-> $errorMessage');
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
      if (data['success'] == true) {
        setState(() {
          cuisinesData.addAll(data['data']);
          data['data'].forEach((e) {
            cuisine.add(e['name']);
          });
          if(cuisinesID != null){
            for (var food in cuisinesData) {
              if (food['id'] == cuisinesID) {
                setState(() {
                  cuisines.text = food['name'];

                  selecteOptionID = food['id'];
                  print('--------cuisine------> $cuisineselecteOption');
                  print('--------cuisine------> $selecteOptionID');

                });
                break; // Exit the loop once you find the matching food
              }
            }
          }
        });
        setState(() {
          // isLoading = false;
        });
        // log('-----cuisine--------> ${cuisinesData}');
      } else {
        String errorMessage = data['message'];
        print('error :-> $errorMessage');
      }
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr cuisine:-> $e');
    }
  }

  @override
  void initState() {
    if (widget.id != null) {
      getFoods();
    }
    print('------------------Time-----------> ${'${fromselectedTime?.hour.toString().padLeft(2, '0')}:${fromselectedTime?.minute.toString().padLeft(2, '0')}'}');
    cuisineList();
    if (widget.id == null) {
      getfoodCategory();
    }

    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    if (_selectedImages != null && _selectedImages!.length >= 5) {
      return;
    }
    final List<XFile>? result = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      maxWidth: 800,
    );
    if (result != null) {
      setState(() {
        _selectedImages = [...?_selectedImages, ...result.take(5 - _selectedImages!.length)];
      });
      _selectedImages?.forEach((e) async {
          final bytes = (await e.readAsBytes()).lengthInBytes;
          final kb = bytes / 1024;
          final mb = kb / 1024;
          if (2000 > kb) {
            ThumbImages?.add(e);
            isBigImage = false;
            print("------------Size Down ------> ${kb}");
          } else {
            isBigImage = true;
            print("------------Image size Up ------> ${kb}");
          }
      });
    }
    // final XFile? pickedImage =
    //     await _picker.pickImage(source: ImageSource.gallery);
    // if (pickedImage != null) {
    //   final bytes = (await pickedImage.readAsBytes()).lengthInBytes;
    //   final kb = bytes / 1024;
    //   final mb = kb / 1024;
    //   print("------------bytes------> ${bytes}");
    //
    //   setState(() {
    //     if (2000 > kb) {
    //       _image = File(pickedImage.path);
    //       isBigImage = false;
    //       print("------------Size Down ------> ${kb}");
    //     } else {
    //       isBigImage = true;
    //       print("------------Image size Up ------> ${kb}");
    //     }
    //   });
    // }
  }

  Future<void> _openImagePickerCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final bytes = (await pickedImage.readAsBytes()).lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

        if (10000 > kb) {
          final croppedFile = await ImageCropper().cropImage(sourcePath: pickedImage.path, compressFormat: ImageCompressFormat.jpg, compressQuality: 100,
            aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
            uiSettings: [ IOSUiSettings(title: ''),AndroidUiSettings(toolbarTitle: '',toolbarColor: Colors.black, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: true),],);

          if (croppedFile != null) {
            setState(() {
              _image =   File(croppedFile.path);
            });
          }
          isBigImage = false;
        } else {
          isBigImage = true;
          // Fluttertoast.showToast(
          //   msg: 'Please select images smaller than 2MB',
          //   fontSize: 16,
          //   backgroundColor: black,
          //   gravity: ToastGravity.BOTTOM,
          //   textColor: white,
          // );
          // _openImagePickerCamera();
          print("------------Image size Up ------> ${kb}");
        }

    }
  }

  Future<void> _openImagePickerGallary() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
     print(pickedImage!.path);
    final bytes = (await pickedImage.readAsBytes()).lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    print("hello");
    setState(() async {
      print("hello1");
      if (10000 > kb) {
        final croppedFile = await ImageCropper().cropImage(sourcePath: pickedImage.path, compressFormat: ImageCompressFormat.jpg, compressQuality: 100,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          uiSettings: [ IOSUiSettings(title: ''),AndroidUiSettings(toolbarTitle: '',toolbarColor: Colors.black, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: true),],);

        if (croppedFile != null) {
          setState(() {
            _image =   File(croppedFile.path);
          });
        }
        print("------------Size Down ------> ${kb}");
        isBigImage = false;
      } else {
        isBigImage = true;
        // Fluttertoast.showToast(
        //   msg: 'Please select images smaller than 2MB',
        //   fontSize: 16,
        //   backgroundColor: black,
        //   gravity: ToastGravity.BOTTOM,
        //   textColor: white,
        // );
        // _openImagePickerCamera();
        print("------------Image size Up ------> ${kb}");
      }
    });
    }

  Map<String, String> TimeSlote = {};
  String? strfrom;
  String? strto;

  Future<void> _selectTime(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromselectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != fromselectedTime) {
      setState(() {
        String toTime;
        fromselectedTime = picked;
        String fromTime = _formatTimeOfDay(fromselectedTime!);
        if(toselectedTime != null)
        toTime = _formatTimeOfDay(toselectedTime!); // Assuming toselectedTime is defined elsewhere
        else
         toTime = '';


        TimeSlote = {"from": fromTime, "to": toTime};
        print('----individualDetails--->${TimeSlote}');
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    String hour = timeOfDay.hour.toString();
    String minute = timeOfDay.minute.toString().padLeft(2, '0');
    String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> selectTime(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: toselectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != toselectedTime) {
      setState(() {
        toselectedTime = picked;
        String fromTime = _formatTimeOfDay(fromselectedTime!); // Assuming fromselectedTime is defined elsewhere
        String toTime = _formatTimeOfDay(toselectedTime!);

        TimeSlote = {"from": fromTime, "to": toTime};
        print('----individualDetails--->${TimeSlote}');
      });
    }
  }

  List category = ['Breakfast', 'Lunch', 'Snacks','Dinner'];

  String selectedOptionCategory = '';
  var selectedOptionCategoryID;
  List<String> selectedCts = [];
  List<String> selectedCtsIDs = [];

  void showRadioButtonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return multiCatDialog(
          selectCts: FoodNameCategory,
          selectedCts: selectedCts,
          selectedCtsID: selectedCtsIDs,
          onSelectedCtsChanged: (updatedCts) {
            setState(() {
              selectedCts = updatedCts;
              print('---------Name---------> $selectedCts');
            });
          },
          onSelectedCtsChangedID: (updatedCtsID ) {
            print(updatedCtsID);
            setState(() {
              selectedCtsIDs = updatedCtsID;
            });
          print('---------ID---------> ${selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}');
        },
        );
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return CatDialog(
    //       options: FoodNameCategory,
    //       onOptionSelectedID: (value) {
    //         setState(() {
    //           selectedOptionCategoryID = value;
    //           // print('----selectedOptionCategoryID------> $value');
    //         });
    //       },
    //       selectedOption: selectedOptionCategory,
    //       onOptionSelected: (String value) {
    //         setState(() {
    //           selectedOptionCategory = value;
    //           print(selectedOptionCategory);
    //           // print('--> $value');
    //         });
    //       },
    //     );
    //   },
    // );
  }

  List name = ['Dosa', 'Idli Vada', 'Samosa', 'Pizza'];

  String cuisineselecteOption = '';
  int? selecteOptionID;

  List Names = ['Pav Bhaji', 'Burger', 'Fries', 'Pasta'];

  String selecteOptionNameIndividual = '';
  int? selecteOptionIDIndividual;



  void logout() async {
    try {
      const url = '${Url}settings';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );
     // print('${response.body}');

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
      log('Errorrrr logout:-> $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (widget.id != null) {
      return (await Navigator.pushReplacement(
              context,
          NoBlinkPageRoute(
                  builder: (context) => const bottom_screen(
                        pageindex: 1,
                      )))) ??
          false;
    } else {
      return (await Navigator.pushReplacement(
              context,
          NoBlinkPageRoute(
                  builder: (context) => const bottom_screen()))) ??
          false;
    }
  }

  var selectedName;
  var selectedNameIndividual;

  // var selectedNameCategory;
  var description;

  List Name_ = [];
  List Price_ = [];
  List Image_ = [];
  List<DateTime> EditDate = [];
  bool? isloading;


  void getFoods() async {
    // try {
      final url = '${Url}foods/${widget.id}';
      setState(() {
        isLoading = true;
      });
      print('step 1--->');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );
      data = json.decode(response.body);
      log(response.body);
      setState(() {
        if(response.statusCode==200||response.statusCode==201) {
          if (data['success'] == true) {
            setState(() {
              print('step 4--->');
              FoodDetails.add(data['data']);
              signaturefood = FoodDetails[0]['is_signature_food']=='0'?false:true;
              selectedName = FoodDetails[0]['name'] == null ? null : FoodDetails[0]['name'];
              print('step 5--->');
              // getfoodname(selectID: selectedName);
              int typeValue = int.parse(FoodDetails[0]['type']) ?? 1;
              selectedValue = typeValue;
              discountcontroller = TextEditingController(
                  text: FoodDetails[0]['food_preparation_time'].toString() != 'null'
                      ? FoodDetails[0]['food_preparation_time'].toString()
                      : '0');

              discountcontroller.selection = TextSelection.fromPosition(
                  TextPosition(offset: discountcontroller.text.length));
              price2controller =
                  TextEditingController(text: "${FoodDetails[0]['price']}");
              price2controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: price2controller.text.length));



              selectedOptionCategoryID = FoodDetails[0]['category_id'];

              foodName = TextEditingController(text: FoodDetails[0]['name']);
              print('step 6--->');


                getfoodCategory(selectID: selectedOptionCategoryID);



              final ID = int.parse(FoodDetails[0]['cuisine_id']);
              print(
                  '-------------------------------------------------> $ID');
              cuisineList(cuisinesID: ID);

              selectedNameIndividual = FoodDetails[0]['separate_item'].isNotEmpty
                  ? FoodDetails[0]['separate_item'][0]['name']
                  : "";
              print('step 7--->');
              // getfoodnameIndividual(selectID: selectedNameIndividual);

              descriptionController.text = FoodDetails[0]['description'];
              standardController.text = FoodDetails[0]['standards'];

              // selectedValue =FoodDetails[0]['type'];
              // print('---->step 8 -->$selectedValue');


              addmemberController = TextEditingController(text: '1');

              ///   ==============================time slots============================================


              // TimeOfDay? fromTimeOfDay;
              // TimeOfDay? toTimeOfDay;
              //
              // String fromTimeString = FoodDetails[0]['time_slots']['from'];
              // print('From Time String: $fromTimeString');
              //
              // if (fromTimeString != 'null') {
              //   // Extracting hour and minute values from the string
              //   RegExp regExp = RegExp(r'(\d+):(\d+)');
              //   Iterable<RegExpMatch> matches = regExp.allMatches(fromTimeString);
              //   print(matches.length);
              //   if (matches.isNotEmpty) {
              //     Match match = matches.first;
              //     int fromHour = int.parse(match.group(1)!);
              //     int fromMinute = int.parse(match.group(2)!);
              //     fromTimeOfDay = TimeOfDay(hour: fromHour, minute: fromMinute);
              //     fromselectedTime = fromTimeOfDay;
              //     TimeSlote = {"from": "$fromTimeOfDay", "to": "$toTimeOfDay"};
              //     print('-------------from --> $fromTimeOfDay');
              //   }
              // }
              //
              // String toTimeString = FoodDetails[0]['time_slots']['to'];
              // print('To Time String: $toTimeString');
              //
              // if (toTimeString != 'null') {
              //   // Extracting hour and minute values from the string
              //   RegExp regExp = RegExp(r'(\d+):(\d+)');
              //   Iterable<RegExpMatch> matches = regExp.allMatches(toTimeString);
              //
              //   if (matches.isNotEmpty) {
              //     Match match = matches.first;
              //     int toHour = int.parse(match.group(1)!);
              //     int toMinute = int.parse(match.group(2)!);
              //     toTimeOfDay = TimeOfDay(hour: toHour, minute: toMinute);
              //     toselectedTime = toTimeOfDay;
              //     TimeSlote = {"from": "$fromTimeOfDay", "to": "$toTimeOfDay"};
              //     print('-------------to --> $toTimeOfDay');
              //   }
              // }

              isChecked = FoodDetails[0]['separate_item'].isNotEmpty ? true : false;
              isChecked2 = FoodDetails[0]['everyday'].toString()=='1' ? true : false;
print('-------date--> ${FoodDetails[0]['dates']}');
              if(FoodDetails[0]['dates'].isNotEmpty||FoodDetails[0]['dates']!=''){
                String dateString = FoodDetails[0]['dates']??''.toString();
                  List<String> dateStrings = dateString.split(',');

                  List<DateTime> dateList = dateStrings.map((dateStr) {
                    // Split the date string into day, month, and year parts
                    List<String> parts = dateStr.split('-');

                    // Parse the parts into integers
                    int day = int.parse(parts[0]);
                    int month = int.parse(parts[1]);
                    int year = int.parse(parts[2]);

                    // Create a DateTime object
                    return DateTime(year, month, day);
                  }).toList();
                  dateList.forEach((e) {
                    print('------------EditeDate---------> e ${e}');
                    setState(() {
                      EditDate.add(e);
                    });
                  });


                // List ab = FoodDetails[0]['dates'];

              }
              if(FoodDetails[0]['everyday']=="1"){
                setState(() {
                  EditDate = [];
                });
              }
              // FoodDetails[0]['dates'];
              // EditDate = FoodDetails[0]['dates'];
              print('------------EditeImage---------> $EditDate');
              if(FoodDetails[0]['media'].isNotEmpty){
                editimage = FoodDetails[0]['media'][0]['thumb'];
                print('------------EditeImage---------> ${editimage}');
              }
              print('step 10--->');
              // print(FoodDetails[0]['separate_item'][0]);
              if (FoodDetails[0]['separate_item'] != null ||
                  FoodDetails[0]['separate_item'] != [] ||
                  FoodDetails[0]['separate_item'].isNotEmpty) {
                for (int i = 0; i < FoodDetails[0]['separate_item'].length; i++) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  print('step 11--->');
                  extraItems.add(ExtraItemsModel(
                      name: FoodDetails[0]['separate_item'][i]['name'],
                      images: FoodDetails[0]['separate_item'][i]['image'],
                      price: FoodDetails[0]['separate_item'][i]['price']));
                  print('step 12--->');
                  // });
                }
                setState(() {});
              }
              if (widget.calander == true) {


                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    curve: Curves.easeInOut,
                  );
                });
              }
              // storage.write('AddItem', cards);
              // print('--------------------------------------------------------------------------------------------------------------------------2 ${cards.length}');
              // print('--------------------------------------------------------------------------------------------------------------------------2 ${storage.read('AddItem').length}')
              // descriptionController = FoodDetails[0]['description'];
            });
            print('step 13--->');
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
        }else if(response.statusCode==401||response.statusCode==400){
          Navigator.of(context).pushReplacement(
            NoBlinkPageRoute(
              builder: (context) => const start_screen(),
            ),
          );
          storage.remove('email_verified');
          storage.remove('api_token_login');
        }
        setState(() {
          if (data['success'] == false){
            Wid_Con.toastmsgr(context: context,msg:data['message']);
            Navigator.pushReplacement(
                context,
                NoBlinkPageRoute(
                    builder: (context) => const bottom_screen(
                      pageindex: 1,
                    )));
            isLoading = false;
          }

        });
      });
    // } catch (e) {
    //   // Handle other error scenarios like network issues or unexpected responses
    //   log('Errorrrr GetFoodDetails: $e');
    // }
  }


  void getfoodCategory({var selectID}) async {
    FoodNameCategory.clear();
    print(' step--> 1');
    try {
      setState(() {
         isLoading = true;
      });
      const url = '${FoodCategoryUrl}categories';

      final response = await http.get(
        Uri.parse(url),
      );
      print(' step--> 2');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' step--> 3');
        final data = json.decode(response.body);
        print(' step--> 4');
        setState(() {
          if (data['success'] == true) {
            print(' step--> 5');
            setState(() {
              FoodNameCategory.addAll(data['data']);
              print(' step--> 6 $FoodNameCategory');

              if (selectID != null) {
                List catlist = (selectID.split(','));
                print(' step--> 7 $selectID');
                for (var food in data['data']) {
                  print(' step--> 8 ');
                  for(var foods in catlist){
                    if (food['id'].toString().contains(foods)) {
                      // setState(() {
                      print(' step--> 9 ${food['id']}');
                      // print('Category---------> ${food['name']}');
                      selectedCts.add(food['name_time']);
                      selectedCtsIDs.add(food['id'].toString());

                      // });

                    }
                  }

                }
                print('------Category----> $selectedCtsIDs');
              }
              setState(() {
                 isLoading = false;
              });
            });
          } else {
            setState(() {
              isLoading = false;
            });
            String errorMessage = data['message'];
            Wid_Con.toastmsgr(context: context,msg:errorMessage);
            print('error :-> $errorMessage');
          }
        });
      }else if(response.statusCode==401||response.statusCode==400){
        Navigator.of(context).pushReplacement(
          NoBlinkPageRoute(
            builder: (context) => const start_screen(),
          ),
        );
        storage.remove('email_verified');
        storage.remove('api_token_login');
      }
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr Category:-> $e');
    }
  }

  Future<void> calanderAPI({String? FoodID,String? Dates}) async {
    const url = '${Url}food-dates-update';
    setState(() {
      isloading = true;
    });

    final response = await http.post(
      Uri.parse(url),
      body: {
        'food_id': FoodID,
        'dates[]': Dates,
      },
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );
    final data = json.decode(response.body);
    // print('-----------body-----> ${response.body}');
    if(response.statusCode==200||response.statusCode==201) {
      if (data['success'] == true) {
        print('----------------> ${response.body}');
        setState(() {
          isloading = false;
        });
        // Fluttertoast.showToast(
        //   msg: 'Saved dates successfully',
        //   fontSize: 16,
        //   backgroundColor: black,
        //   gravity: ToastGravity.BOTTOM,
        //   textColor: white,
        // );
        Wid_Con.toastmsgg(context: context,msg:'Saved dates successfully',);
        log('--------response-----> $data');
      }else{
        print('----------------> ${response.body}');
        // Fluttertoast.showToast(
        //   msg: data['message'][0],
        //   fontSize: 16,
        //   backgroundColor: black,
        //   gravity: ToastGravity.BOTTOM,
        //   textColor: white,
        // );
        Wid_Con.toastmsgr(context: context,msg:data['message'][0],);
        setState(() {
          isloading = false;
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


  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color(0xFFF5F5F5),
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
              titel: widget.id != null
                  ? 'EDIT FOODS | FOODS MANAGEMENT'
                  : 'ADD FOODS | FOODS MANAGEMENT',
              fontweight: FontWeight.w600,
              actions: [
                SizedBox(width: 6.w,)
                // Padding(
                //   padding: const EdgeInsets.only(right: 8),
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const profile_screen()));
                //     },
                //     child: Icon(
                //       Icons.account_circle_outlined,
                //       color: grey,
                //     ),
                //   ),
                // ),
              ],
            ),
            drawer: Wid_Con.drawer(
                width: MediaQuery.of(context).size.width * 0.75,
                onPressedfav: () {
                  Navigator.pop(context);

                },
                onpressBannerimage: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      NoBlinkPageRoute(builder: (context) =>  ImageSelectionScreen()));
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const Orders_Screen()));
                },
                onPresprivacypolicy: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      NoBlinkPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
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
            bottomNavigationBar:widget.id==null?null: Bottombar(),
            body: isLoading == false
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: SingleChildScrollView(
                    controller: _scrollController,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category',
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 14,
                                          color: bluefont,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      showRadioButtonDialog();
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: grey300),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  selectedCts.isEmpty
                                                      ? 'Choose Item'
                                                      : selectedCts.toString().replaceAll('[', '').replaceAll(']', ''),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 13, color: grey)),
                                            ),

                                            Icon(Icons.keyboard_arrow_down,
                                                size: 20, color: grey),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text('Cuisines',
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 14,
                                          color: bluefont,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 35,
                                    child: CustomDropdown.search(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: grey300),
                                      hintText: cuisineselecteOption.isEmpty
                                          ? 'Choose Item'
                                          : cuisineselecteOption,
                                      selectedStyle: TextStyle(
                                          fontSize: 13, color: grey),
                                      hintStyle: TextStyle(
                                          fontSize: 13, color: grey),
                                      items: cuisine.isEmpty ? [''] : cuisine,

                                      controller: cuisines,

                                      onChanged: (value) {
                                        setState(() {

                                          for (var food in cuisinesData) {
                                            if (food['name'] == value) {
                                              setState(() {
                                                cuisines.text = food['name'];

                                                cuisineselecteOption = value;
                                                selecteOptionID = food['id'];
                                                print('--------cuisine------> $cuisineselecteOption');
                                                print('--------cuisine------> $selecteOptionID');

                                              });
                                              break; // Exit the loop once you find the matching food
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Food Type',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 14,
                                        color: bluefont,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Radio(
                                          activeColor: const Color(0xFFE07D29),
                                          value: 1,
                                          groupValue: selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              selectedValue = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Text('Dine in',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: fontfamily,
                                          )),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Radio(
                                          activeColor: const Color(0xFFE07D29),
                                          value: 2,
                                          groupValue: selectedValue,
                                          onChanged: (value) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            setState(() {
                                              selectedValue = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Text('Delivery',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: fontfamily,
                                          )),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Radio(
                                          activeColor: const Color(0xFFE07D29),
                                          value: 3,
                                          groupValue: selectedValue,
                                          onChanged: (value) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            setState(() {
                                              selectedValue = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Text('Both',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: fontfamily,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 0.3,
                                    color: grey,
                                    width: double.infinity,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        'Signature Food?',
                                        style: TextStyle(
                                            fontFamily: fontfamily,
                                            fontSize: 14,
                                            color: bluefont,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Checkbox(
                                        activeColor: red,
                                        value: signaturefood,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            signaturefood = value!;
                                            print(signaturefood);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Full Dish',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 14,
                                        color: bluefont,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontFamily: fontfamily,
                                            fontSize: 14,
                                            color: bluefont,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 35,
                                        child: TextFormField(
                                          textCapitalization: TextCapitalization.words,
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'Poppins'),
                                          controller: foodName,
                                          cursorColor: grey,
                                          // keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                    color: grey300, width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: grey300, width: 1),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 0),
                                            hintStyle: TextStyle(
                                                color: grey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: fontfamily),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Food Thumb Image',
                                            style: TextStyle(
                                                fontFamily: fontfamily,
                                                fontSize: 14,
                                                color: bluefont,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 5),
                                          const ElTooltip(
                                            child: Icon(Icons.info_outline, size: 17,),
                                            content: Text('1:1 Aspect Ratio Required.'),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _image != null
                                          ? GestureDetector(
                                              onTap: () {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                "Upload Image"),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Wid_Con.button(
                                                                  titelcolor:
                                                                      white,
                                                                  onPressed:
                                                                      () async {
                                                                        _openImagePickerGallary();

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  ButtonRadius: 5,
                                                                  ButtonName:
                                                                      'Gallery',
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Wid_Con.button(
                                                                  titelcolor:
                                                                      white,
                                                                  ButtonRadius: 5,
                                                                  ButtonName:
                                                                      'Camera',
                                                                  onPressed:
                                                                      () {
                                                                    _openImagePickerCamera();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                height: 110,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: transparent,
                                                  border: Border.all(
                                                      color: grey300, width: 0.7),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Image.file(_image!,
                                                    fit: BoxFit.fitHeight),
                                               /* GridView.builder(
                                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100),
                                                  itemCount:ThumbImages?.length,
                                                  itemBuilder: (context, index) =>  Container(
                                                    height: 50,width: 50,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(image: FileImage(File(ThumbImages![index].path)),fit: BoxFit.cover)
                                                    ),
                                                  ),
                                                ),*/
                                              ),
                                            )
                                          : editimage == ''
                                              ? InkWell(
                                                child: Container(
                                                  height: 110,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: transparent,
                                                    border: Border.all(
                                                        color: grey300, width: 0.7),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/gallery.png',
                                                          height: 50,
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          'Select File',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                fontfamily,
                                                            fontSize: 11,
                                                            color: greyfont,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                  onTap: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    showDialog(
                                                        context:
                                                        context,
                                                        builder:
                                                            (context) {
                                                          return AlertDialog(
                                                            title:
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                const Text(
                                                                    "Upload Image"),
                                                                const SizedBox(
                                                                  height:
                                                                  15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(child : Wid_Con.button(
                                                                      titelcolor: white,
                                                                      onPressed: () async {
                                                                        _openImagePickerGallary();
                                                                        Navigator.pop(context);
                                                                      },
                                                                      ButtonName: 'Gallery',
                                                                      ButtonRadius: 5
                                                                    ))
,
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(child: Wid_Con.button(
                                                                      titelcolor: white,
                                                                      ButtonRadius: 5,
                                                                      ButtonName: 'Camera',
                                                                      onPressed: () {

                                                                        _openImagePickerCamera();
                                                                        Navigator.pop(context);
                                                                      },
                                                                    ))
,
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  }
                                              )
                                              : GestureDetector(
                                                  onTap: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                    "Upload Image"),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Wid_Con
                                                                        .button(
                                                                      titelcolor:
                                                                          white,
                                                                      onPressed:
                                                                          () async {
                                                                            _openImagePickerGallary();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      ButtonName:
                                                                          'Gallery',
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Wid_Con
                                                                        .button(
                                                                      titelcolor:
                                                                          white,
                                                                      ButtonName:
                                                                          'Camera',
                                                                      onPressed:
                                                                          () {
                                                                        _openImagePickerCamera();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 110,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: transparent,
                                                      border: Border.all(
                                                          color: grey300, width: 0.7),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Image.network(
                                                        editimage,
                                                        fit: BoxFit.fitHeight),
                                                  ),
                                                ),
                                      isBigImage == true
                                          ? Text(
                                              'Please select images smaller than 10MB',
                                              style: TextStyle(
                                                fontFamily: fontfamily,
                                                fontSize: 11,
                                                color: red,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(width: 35.w,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                             SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              'Price',
                                              style: TextStyle(
                                                  fontFamily: fontfamily,
                                                  fontSize: 10.sp,
                                                  color: bluefont,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              child: TextFormField(
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: grey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w200,
                                                    fontFamily: 'Poppins'),
                                                controller: price2controller,
                                                cursorColor: grey,
                                                keyboardType:
                                                TextInputType.number,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(5),
                                                      borderSide: BorderSide(
                                                          color: grey300,
                                                          width: 1)),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    borderSide: BorderSide(
                                                        color: grey300, width: 1),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                  ),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                                  hintStyle: TextStyle(
                                                      color: grey,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w200,
                                                      fontFamily: 'Poppins'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //  SizedBox(
                                      //   width: 3.w,
                                      // ),
                                      Container(width: 35.w,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Food preparation time (in minutes)',
                                              style: TextStyle(
                                                  fontFamily: fontfamily,
                                                  fontSize: 9.sp,
                                                  color: bluefont,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              child: TextFormField(
                                                style: TextStyle(
                                                    color: grey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w200,
                                                    fontFamily: 'Poppins'),
                                                controller: discountcontroller,
                                                cursorColor: grey,
                                                keyboardType:
                                                TextInputType.number,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(5),
                                                      borderSide: BorderSide(
                                                          color: grey300,
                                                          width: 1)),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    borderSide: BorderSide(
                                                        color: grey300, width: 1),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                  ),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                                  hintStyle: TextStyle(
                                                      color: grey,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w200,
                                                      fontFamily: fontfamily),
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
                                  // Text(
                                  //   'Time Slots',
                                  //   style: TextStyle(
                                  //       fontFamily: fontfamily,
                                  //       fontSize: 14,
                                  //       color: bluefont,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  // const SizedBox(height: 15),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: SizedBox(
                                  //         height: 35,
                                  //         child: TextFormField(
                                  //
                                  //           style: TextStyle(color: grey),
                                  //           readOnly: true,
                                  //           expands: false,
                                  //           controller: TextEditingController(
                                  //               text: fromselectedTime
                                  //                       ?.format(context) ??
                                  //                   ''),
                                  //           onTap: () => _selectTime(context),
                                  //           decoration: InputDecoration(
                                  //             hintText: 'From time',
                                  //               hintStyle: TextStyle(color: grey,fontSize: 14),
                                  //               isDense: true,
                                  //               contentPadding:
                                  //                   const EdgeInsets.symmetric(
                                  //                       horizontal: 10,
                                  //                       vertical: 10),
                                  //               suffixIcon: Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(10.0),
                                  //                 child: Image.asset(
                                  //                   'assets/images/timeslots.png',
                                  //                 ),
                                  //               ),
                                  //               focusedBorder: OutlineInputBorder(
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(5),
                                  //                   borderSide: BorderSide(
                                  //                       color: grey300,
                                  //                       width: 1)),
                                  //               enabledBorder: OutlineInputBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(5),
                                  //                 borderSide: BorderSide(
                                  //                     color: grey300, width: 1),
                                  //               ),
                                  //               border: OutlineInputBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(5),
                                  //               ),
                                  //               suffixIconColor: grey),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //     Container(
                                  //       height: 1,
                                  //       color: black,
                                  //       width: 10,
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //     Expanded(
                                  //       child: SizedBox(
                                  //         height: 35,
                                  //         child: TextFormField(
                                  //           style: TextStyle(color: grey),
                                  //           readOnly: true,
                                  //           expands: false,
                                  //           controller: TextEditingController(
                                  //               text: toselectedTime
                                  //                       ?.format(context) ??
                                  //                   ''),
                                  //           onTap: () => selectTime(context),
                                  //           decoration: InputDecoration(
                                  //               hintText: 'To time',
                                  //               hintStyle: TextStyle(color: grey,fontSize: 14),
                                  //               isDense: true,
                                  //               contentPadding:
                                  //                   const EdgeInsets.symmetric(
                                  //                       horizontal: 10,
                                  //                       vertical: 10),
                                  //               suffixIcon: Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(10.0),
                                  //                 child: Image.asset(
                                  //                   'assets/images/timeslots.png',
                                  //                 ),
                                  //               ),
                                  //               focusedBorder: OutlineInputBorder(
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(5),
                                  //                   borderSide: BorderSide(
                                  //                       color: grey300,
                                  //                       width: 1)),
                                  //               enabledBorder: OutlineInputBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(5),
                                  //                 borderSide: BorderSide(
                                  //                     color: grey300, width: 1),
                                  //               ),
                                  //               border: OutlineInputBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(5),
                                  //               ),
                                  //               suffixIconColor: grey),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 14,
                                        color: bluefont,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    maxLines: 5,
                                    style: TextStyle(color: grey),
                                    controller: descriptionController,
                                    textCapitalization: TextCapitalization.words,
                                    decoration: InputDecoration(
                                        // isDense: true,
                                      hintText: 'Description',
                                        hintStyle: TextStyle(
                                          color: grey300
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: grey300,
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: grey300, width: 1),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                        suffixIconColor: grey),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Standard Portion',
                                    style: TextStyle(
                                        fontFamily: fontfamily,
                                        fontSize: 14,
                                        color: bluefont,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    maxLines: 1,
                                    style: TextStyle(color: grey),
                                    controller: standardController,
                                   // textCapitalization: TextCapitalization.words,
                                    decoration: InputDecoration(
                                      // isDense: true,
                                        hintText: 'Ex: 250 GM - for 2 people',
                                        hintStyle: TextStyle(
                                            color: grey300
                                        ),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: grey300,
                                                width: 1)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: grey300, width: 1),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                        suffixIconColor: grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        /*  Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors.blue,
                                        ),
                                        child: Checkbox(
                                          activeColor: blue,
                                          value: isChecked,
                                          checkColor: Colors.white,
                                          onChanged: (bool? value) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            setState(() {
                                              isChecked = value ?? false;
                                              print('------------------------------> $isChecked');
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        'Individual Items',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: blue,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isChecked)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 15),
                                        Wid_Con.button(
                                          ButtonName: '+ Add Item',
                                          onPressed: () {
                                            setState(() {
                                              extraItems.add(ExtraItemsModel(name: '', images: '', price: ''));
                                            });
                                          },
                                          height: 35,
                                          width: 100,
                                          fontSize: 11,
                                          ButtonRadius: 5,
                                          titelcolor: Colors.white,
                                        ),
                                        const SizedBox(height: 15),
                                        ListView.builder(
                                          itemCount: extraItems.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, i) {
                                            return _ExtraItems(
                                              extraItemsModel: extraItems[i],
                                              onRemove: () {
                                                // Remove the item from the list when notified
                                                setState(() {
                                                  extraItems.removeAt(i);
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                            ),
                          ),*/
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors.blue,
                                        ),
                                        child: Checkbox(
                                          activeColor: blue,
                                          value: isChecked2,
                                          checkColor: Colors.white,
                                          onChanged: (bool? value) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            setState(() {
                                              isChecked2 = value ?? false;
                                              print('------------------------------> $isChecked2');
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        'Everyday',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: blue,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isChecked2)
                                    Container()
                                  else
                                    SfDateRangePicker(
                                      enablePastDates : false,
                                      initialSelectedDates: EditDate,
                                      headerStyle: DateRangePickerHeaderStyle(
                                        textStyle: TextStyle(
                                            color: blue,
                                            fontSize: 18,
                                            fontFamily: fontfamily,
                                            fontWeight: FontWeight.w500),

                                      ),
                                      monthCellStyle: DateRangePickerMonthCellStyle(
                                        textStyle: TextStyle(
                                          color: blue,
                                          fontFamily: fontfamily,
                                        ),

                                      ),
                                      controller: DatesController,

                                      selectionColor: Colors.orange[300],
                                      onSelectionChanged: _onSelectionChanged,
                                      selectionMode: DateRangePickerSelectionMode.multiple,
                                      initialSelectedRange: PickerDateRange(
                                          DateTime.now().subtract(const Duration(days: 4)),
                                          DateTime.now().add(const Duration(days: 3))),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(child: Wid_Con.button(
                                ButtonName: 'Save Food',
                                onPressed: () async {

                                  FocusManager.instance.primaryFocus?.unfocus();
                                  print('----Time--->${TimeSlote}');
                                  print('----Standards--->${standardController.text}');
                                  print(
                                      '------------selecteOptionID--------> ${selecteOptionID}');
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if(isChecked == true && extraItems.isNotEmpty){

                                    if(extraItems[extraItems.length -1].name.isEmpty){
                                     // Fluttertoast.showToast(msg: "Please Individual item name is required");
                                      Wid_Con.toastmsgr(context: context,msg:"Please Individual item name is required");
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    else if(extraItems[extraItems.length -1].price.isEmpty){
                                     // Fluttertoast.showToast(msg: "Please Individual item price is required");
                                      Wid_Con.toastmsgr(context: context,msg:"Please Individual item price is required");
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    else if(extraItems[extraItems.length -1].images.isEmpty){
                                     // Fluttertoast.showToast(msg: "Please Individual item image is required");
                                      Wid_Con.toastmsgr(context: context,msg:"Please Individual item image is required");
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    else {
                                      if (widget.id == null) {


                                        print(
                                            '-----type---> ${selectedValue} null');
                                        print('-----name---> ${foodName.text} ' '');
                                        print(
                                            '-----price---> ${price2controller.text} '
                                                '');
                                        print(
                                            '-----Description---> $Description' '');
                                        // print('-----TimeSlote---> ${TimeSlote}');
                                        print('-----image---> ${_image} null');

                                        // print(
                                        //     '---->step 1 ${selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}');
                                        // try {
                                        const url = '${Url}foods';


                                        var request = http.MultipartRequest(
                                            'POST', Uri.parse(url))
                                          ..headers.addAll(
                                            {
                                              "Authorization":
                                              "Bearer ${storage.read('api_token_login')}"
                                            },
                                          );


                                        if (selectedCtsIDs.isNotEmpty) {
                                          request.fields['category_id'] =
                                              selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
                                          print('--------selectedOptioncuisineID--S1----------->');
                                        }
                                        if (selecteOptionID!=null) {
                                          print('--------selectedOptioncuisineID--isNotEmpty------------>');
                                          request.fields['cuisine_id'] =
                                              selecteOptionID.toString();
                                        }
                                        if (selectedValue!=null) {
                                          print('--------selectedValue--isNotEmpty------------>');
                                          request.fields['type'] =
                                              selectedValue.toString();
                                        }
                                        if (foodName.text.isNotEmpty) {
                                          print('--------foodName--isNotEmpty------------>');
                                          request.fields['name'] =
                                              foodName.text.toString();
                                        }
                                        if (discountcontroller.text.isNotEmpty) {
                                          print('--------price2controller--isNotEmpty------------>');
                                          request.fields['food_preparation_time'] =
                                              discountcontroller.text;
                                        }
                                        if (price2controller.text.isNotEmpty) {
                                          print('--------price2controller--isNotEmpty------------>');
                                          request.fields['price'] =
                                              price2controller.text;
                                        }
                                        if (descriptionController.text.isNotEmpty) {
                                          print('--------Description--isNotEmpty------------>');
                                          request.fields['description'] =
                                              descriptionController.text.toString();
                                        }
                                        if (standardController.text.isNotEmpty) {
                                          print('--------Standards--isNotEmpty------------>');
                                          request.fields['standards'] =
                                              standardController.text.toString();
                                        }
                                        print('--signature 1---> $signaturefood');
                                          request.fields['is_signature_food'] =
                                              signaturefood==false?'0':'1';
                                        if (_image!=null) {
                                          print('--------_image--isNotEmpty------------>');
                                          var stream = http.ByteStream(
                                              Stream.castFrom(_image!.openRead()));
                                          var length = await _image!.length();
                                          // print('---->step 3 $stream');
                                          // print('---->step 3 $length');
                                          request.files.add(http.MultipartFile(
                                            'image',
                                            stream,
                                            length,
                                            filename: path.basename(_image!.path),
                                          ));
                                        }
                                        // print(TimeSlote);
                                        // if(TimeSlote['from'].toString()!='null'){
                                        //   request.fields['time_slots[from]'] =
                                        //       TimeSlote['from'].toString();
                                        // }
                                        // if(TimeSlote['to'].toString()!='null'){
                                        //   request.fields['time_slots[to]'] =
                                        //       TimeSlote['to'].toString();
                                        // }
                                        if (extraItems.isNotEmpty) {
                                          for (int i = 0; i < extraItems.length; i++) {
                                            if(extraItems[i].name!=''||extraItems[i].price!=''||extraItems[i].images.isNotEmpty){
                                              var name = extraItems[i].name;
                                              var price = extraItems[i].price;
                                              File image = File(extraItems[i].images);

                                              var fileStreamIND = http.ByteStream(Stream.castFrom(image.openRead()));
                                              var lengthIND = await image.length();
                                              request.files.add(http.MultipartFile(
                                                'separate_item[$i][image]',
                                                fileStreamIND,
                                                lengthIND,
                                                filename: path.basename(image.path),
                                              ));

                                              request.fields['separate_item[$i][name]'] = name.toString();
                                              request.fields['separate_item[$i][price]'] = price.toString();
                                            }

                                            // request.fields['separate_item[$i][image]'] = '';
                                          }
                                        }
                                        if(DatesOfCal.isNotEmpty){
                                          request.fields['dates[]'] =
                                              DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '');
                                          // DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '')
                                        }
                                        if (isChecked2) {
                                          request.fields['everyday'] ="1";
                                        } else{request.fields['everyday'] ="0";}
                                        // try {
                                        var response = await request.send();

                                        if (response.statusCode == 302) {
                                          // Handle redirection
                                          var redirectUrl =
                                          response.headers['location'];
                                          if (redirectUrl != null) {
                                            // Make another request to the new location
                                            var redirectResponse = await http
                                                .get(Uri.parse(redirectUrl));
                                            print(
                                                'Redirected response status code-->: ${redirectResponse.statusCode}');
                                            log('Redirected response status code-->: ${redirectResponse.headers}');
                                            log('Redirected response status code-->: ${redirectResponse.body}');
                                            print(
                                                'Redirection URL not found in headers');
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        } else if (response.statusCode == 200) {
                                          var res = await http.Response.fromStream(
                                              response);
                                          print(res.body);
                                          final result = jsonDecode(res.body)
                                          as Map<String, dynamic>;
                                          Wid_Con.toastmsgg(context: context,msg:'Your food is Added');
                                          setState(() {
                                            isLoading = false;
                                          });
                                          print(
                                              'Food Updated successfully --> ${response.statusCode}');
                                          /* print(
                                          'Image uploaded successfully --> ${response.stream}');*/
                                          print(
                                              'Food Updated successfully --> ${result}');

                                          Navigator.pushReplacement(
                                              context,
                                              NoBlinkPageRoute(
                                                  builder: (context) =>
                                                  const bottom_screen(
                                                    pageindex: 1,
                                                  )));
                                        } else if (response.statusCode == 400||response.statusCode == 401) {
                                          Navigator.of(context).pushReplacement(
                                            NoBlinkPageRoute(
                                              builder: (context) => const start_screen(),
                                            ),
                                          );
                                          storage.remove('email_verified');
                                          storage.remove('api_token_login');
                                        } else {
                                          var res = await http.Response.fromStream(
                                              response);
                                          final result = jsonDecode(res.body)
                                          as Map<String, dynamic>;
                                          if (result['success'] == false) {
                                            Wid_Con.toastmsgr(context: context,msg:result['message'].toString().contains('[')?result['message'][0].toString():result['message'].toString(),);

                                          }
                                        var redirectUrl =
                                        response.headers['location'];
                                          print(
                                              '------> Body: ${redirectUrl}');
                                        if (redirectUrl != null) {
                                          // Make another request to the new location
                                          var redirectResponse = await http
                                              .get(Uri.parse(redirectUrl));
                                          print(
                                              'Failed to upload image. Body: ${redirectResponse.body}');
                                        }
                                          print(
                                              'Failed to upload image. Status code:1 ${response.statusCode}');

                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                      else {
                                        // =========================================== EDIT ==============================================================
                                        List<String> AsDate = [];
                                        print('----------date----------> $DatesOfCal');
                                        setState(() {
                                          EditDate.forEach((e) {
                                            AsDate.add(DateFormat('dd-MM-yyyy').format(e));
                                          });
                                        });
                                        print('----------date----------> $AsDate');
                                        final url =
                                            '${Url}foods-update/${widget.id}';


                                        print('-----type---> ${selectedValue}');
                                        print('-----name---> ${foodName.text}');
                                        print('-----discountcontroller---> ${discountcontroller.text}');
                                        print(
                                            '-----price---> ${price2controller.text}');
                                        print('-----Description---> ${descriptionController.text}');
                                        print('-----TimeSlote---> ${TimeSlote}');
                                        print('-----image---> ${_image}');
                                        // print(
                                        //     '-----individualDetails---> ${individualDetails}');

                                        var request = http.MultipartRequest(
                                            'POST', Uri.parse(url))
                                          ..headers.addAll(
                                            {
                                              "Authorization":
                                              "Bearer ${storage.read('api_token_login')}"
                                            },
                                          );
                                        if (_image != null) {
                                          print(
                                              '-------------chang image----------> ');
                                          var stream = http.ByteStream(
                                              Stream.castFrom(_image!.openRead()));
                                          var length = await _image!.length();
                                          // print('---->step 3 $stream');
                                          // print('---->step 3 $length');
                                          request.files.add(http.MultipartFile(
                                            'image',
                                            stream,
                                            length,
                                            filename: path.basename(_image!.path),
                                          ));
                                        }
                                        if (selectedCtsIDs.isNotEmpty) {

                                          request.fields['category_id'] =
                                              selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
                                          print('--------selectedCtsIDs--S2----------->');
                                        }
                                        if (selecteOptionID!=null) {
                                          request.fields['cuisine_id'] =
                                              selecteOptionID.toString();
                                        }
                                        if (selectedValue!=null) {
                                          print('--------selectedValue--isEmpty------------>');
                                          request.fields['type'] =
                                              selectedValue.toString();
                                        }
                                        if (foodName.text.isNotEmpty) {
                                          print('--------foodName--isEmpty------------>');
                                          request.fields['name'] =
                                              foodName.text.toString();
                                        }
                                        if (discountcontroller.text.isNotEmpty) {
                                          print('--------price2controller--isNotEmpty------------>');
                                          request.fields['food_preparation_time'] =
                                              discountcontroller.text;
                                        }
                                        if (price2controller.text.isNotEmpty) {
                                          print('--------price2controller--isEmpty------------>');
                                          request.fields['price'] =
                                              price2controller.text;
                                        }
                                        if (descriptionController.text.isNotEmpty) {
                                          print('--------Description--isEmpty------------>');
                                          request.fields['description'] =
                                              descriptionController.text.toString();
                                        }
                                        if (standardController.text.isNotEmpty) {
                                          print('--------Standards--isNotEmpty------------>');
                                          request.fields['standards'] =
                                              standardController.text.toString();
                                        }
                                        print('--signature 2---> $signaturefood');
                                        request.fields['is_signature_food'] =
                                        signaturefood==false?'0':'1';
                                        // print('---------------time------> ${TimeSlote.toString()}');
                                        // if(TimeSlote['from'].toString()!='null'){
                                        //   request.fields['time_slots[from]'] =
                                        //       TimeSlote['from'].toString();
                                        // }
                                        // if(TimeSlote['to'].toString()!='null'){
                                        //   request.fields['time_slots[to]'] =
                                        //       TimeSlote['to'].toString();
                                        // }

                                        if (extraItems.isNotEmpty) {
                                          for (int i = 0; i < extraItems.length; i++) {
                                            print('--------index------> $i');

                                            var name = extraItems[i].name;
                                            var price = extraItems[i].price;
                                            File image = File(extraItems[i].images);

                                            if (extraItems[i]
                                                .images
                                                .contains('https')) {
                                              Uri uri =
                                              Uri.parse(extraItems[i].images);
                                              String path = uri.path;

                                              List<String> pathComponents =
                                              path.split('/');

                                              // Extract the desired path components
                                              int startIndex = pathComponents
                                                  .lastIndexOf('public');
                                              String? httpImage;
                                              if (startIndex != -1) {
                                                List<String> desiredPathComponents =
                                                pathComponents
                                                    .sublist(startIndex);
                                                httpImage =
                                                    desiredPathComponents.join('/');

                                                print("Separated path: $httpImage");
                                              } else {
                                                print(
                                                    "Path doesn't contain 'public'");
                                              }

                                              request.fields[
                                              'separate_item[$i][image]'] =
                                                  httpImage.toString();
                                              request.fields[
                                              'separate_item[$i][name]'] =
                                                  name.toString();
                                              request.fields[
                                              'separate_item[$i][price]'] =
                                                  price.toString();
                                            } else {
                                              if(extraItems[i].name!=''||extraItems[i].price!=''||extraItems[i].images.isNotEmpty){
                                                var fileStreamIND = http.ByteStream(
                                                    Stream.castFrom(
                                                        image.openRead()));
                                                var lengthIND = await image.length();

                                                request.files.add(http.MultipartFile(
                                                  'separate_item[$i][image]',
                                                  fileStreamIND,
                                                  lengthIND,
                                                  filename: path.basename(image.path),
                                                ));
                                                request.fields[
                                                'separate_item[$i][name]'] =
                                                    name.toString();
                                                request.fields[
                                                'separate_item[$i][price]'] =
                                                    price.toString();
                                              }
                                            }
                                          }
                                        }

                                        if(isDate==true){
                                          request.fields['dates[]'] =
                                              DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '');
                                          // DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '')
                                        }else{
                                          request.fields['dates[]'] =
                                              AsDate.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '');
                                        }
                                        if (isChecked2) {request.fields['everyday'] ="1";}
                                        else{request.fields['everyday'] ="0";}

                                        // try {
                                        var response = await request.send();
                                        print('-------------response.code-----------> ${response.statusCode}');

                                        if (response.statusCode == 302) {
                                          // Handle redirection
                                          var redirectUrl =
                                          response.headers['location'];
                                          if (redirectUrl != null) {
                                            // Make another request to the new location
                                            var redirectResponse = await http
                                                .get(Uri.parse(redirectUrl));
                                            print(
                                                'Redirected response status code-->: ${redirectResponse.statusCode}');
                                            log('Redirected response status code-->: ${redirectResponse.headers}');
                                            log('Redirected response status code-->: ${redirectResponse.body}');
                                            print(
                                                'Redirection URL not found in headers');
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        } else if (response.statusCode == 200) {
                                          var res = await http.Response.fromStream(
                                              response);
                                          final result = jsonDecode(res.body)
                                          as Map<String, dynamic>;
                                          // return !result['hasErrors'];
                                          // Fluttertoast.showToast(
                                          //   msg: 'Your food is updated',
                                          //   fontSize: 16,
                                          //   backgroundColor: black,
                                          //   gravity: ToastGravity.BOTTOM,
                                          //   textColor: white,
                                          // );
                                          Wid_Con.toastmsgg(context: context,msg:'Your food is updated');
                                          Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> bottom_screen(pageindex: 1,)));
                                          setState(() {
                                            isLoading = false;
                                          });
                                          print(
                                              'Food Updated successfully --> ${response.statusCode}');
                                          print(
                                              'Food Updated successfully --> ${response.stream}');
                                          print(
                                              'Food Updated successfully --> ${result}');
                                          setState(() {
                                            isLoading = false;
                                            isDate = false;
                                          });

                                        }else if (response.statusCode == 400||response.statusCode == 401) {
                                          Navigator.of(context).pushReplacement(
                                            NoBlinkPageRoute(
                                              builder: (context) => const start_screen(),
                                            ),
                                          );
                                          storage.remove('email_verified');
                                          storage.remove('api_token_login');
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          var res = await http.Response.fromStream(
                                              response);
                                          final result = jsonDecode(res.body)
                                          as Map<String, dynamic>;
                                          if (result['success'] == false) {
                                            String transformedString =
                                            result['message']
                                                .map((item) => '"$item",\n')
                                                .join();

                                            // Fluttertoast.showToast(
                                            //   msg: result['message'][0].toString(),
                                            //   fontSize: 16,
                                            //   backgroundColor: black,
                                            //   gravity: ToastGravity.BOTTOM,
                                            //   textColor: white,
                                            // );

                                            Wid_Con.toastmsgg(context: context,msg:result['message'][0].toString(),);
                                          }
                                          var redirectUrl =
                                          response.headers['location'];
                                          if (redirectUrl != null) {
                                            // Make another request to the new location
                                            var redirectResponse = await http
                                                .get(Uri.parse(redirectUrl));
                                            print('status code-->: ${redirectResponse.statusCode}');
                                            log('Redirected response bodyyy-->: ${redirectResponse.body}');
                                          }
                                          print(
                                              'Failed to upload image. Status code:2 ${response.statusCode}');
                                        }
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  else {
                                    if (widget.id == null) {

                                      print(
                                          '-----type---> ${selectedValue} null');
                                      print('-----name---> ${foodName.text} ' '');
                                      print(
                                          '-----price---> ${price2controller.text} '
                                              '');
                                      print(
                                          '-----Description---> $Description' '');
                                      print('-----TimeSlote---> ${TimeSlote}');
                                      print('-----image---> ${_image} null');

                                      print(
                                          '---->s3 ${selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}');
                                      // try {
                                      // print('---->step 2 $_image');
                                      const url = '${Url}foods';


                                      var request = http.MultipartRequest(
                                          'POST', Uri.parse(url))
                                        ..headers.addAll(
                                          {
                                            "Authorization":
                                            "Bearer ${storage.read('api_token_login')}"
                                          },
                                        );

                                      if (selectedCtsIDs.isNotEmpty) {

                                        request.fields['category_id'] =
                                            selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
                                        print('--------selectedCtsIDs--S3------------>');
                                      }
                                      if (selecteOptionID!=null) {
                                        request.fields['cuisine_id'] =
                                            selecteOptionID.toString();
                                      }
                                      if (selectedValue!=null) {
                                        print('--------selectedValue--isNotEmpty------------>');
                                        request.fields['type'] =
                                            selectedValue.toString();
                                      }
                                      if (foodName.text.isNotEmpty) {
                                        print('--------foodName--isNotEmpty------------>');
                                        request.fields['name'] =
                                            foodName.text.toString();
                                      }
                                      if (price2controller.text.isNotEmpty) {
                                        print('--------price2controller--isNotEmpty------------>');
                                        request.fields['price'] =
                                            price2controller.text;
                                      }
                                      if (discountcontroller.text.isNotEmpty) {
                                        print('--------price2controller--isNotEmpty------------>');
                                        request.fields['food_preparation_time'] =
                                            discountcontroller.text;
                                      }
                                      if (descriptionController.text.isNotEmpty) {
                                        print('--------Description--isNotEmpty------------>');
                                        request.fields['description'] =
                                            descriptionController.text.toString();
                                      }
                                      if (standardController.text.isNotEmpty) {
                                        print('--------Standards--isNotEmpty------------>');
                                        request.fields['standards'] =
                                            standardController.text.toString();
                                      }
                                      if (_image!=null) {
                                        print('--------_image--isNotEmpty------------>');
                                        var stream = http.ByteStream(
                                            Stream.castFrom(_image!.openRead()));
                                        var length = await _image!.length();
                                        // print('---->step 3 $stream');
                                        // print('---->step 3 $length');
                                        request.files.add(http.MultipartFile(
                                          'image',
                                          stream,
                                          length,
                                          filename: path.basename(_image!.path),
                                        ));
                                      }
                                      print('--signature 3---> $signaturefood');
                                      request.fields['is_signature_food'] =
                                      signaturefood==false?'0':'1';
                                      // if(TimeSlote['from'].toString()!='null'){
                                      //   request.fields['time_slots[from]'] =
                                      //       TimeSlote['from'].toString();
                                      // }
                                      // if(TimeSlote['to'].toString()!='null'){
                                      //   request.fields['time_slots[to]'] =
                                      //       TimeSlote['to'].toString();
                                      // }
                                      if (extraItems.isNotEmpty) {
                                        for (int i = 0; i < extraItems.length; i++) {
                                          if(extraItems[i].name!=''||extraItems[i].price!=''||extraItems[i].images.isNotEmpty){
                                            var name = extraItems[i].name;
                                            var price = extraItems[i].price;
                                            File image = File(extraItems[i].images);

                                            var fileStreamIND = http.ByteStream(Stream.castFrom(image.openRead()));
                                            var lengthIND = await image.length();
                                            request.files.add(http.MultipartFile(
                                              'separate_item[$i][image]',
                                              fileStreamIND,
                                              lengthIND,
                                              filename: path.basename(image.path),
                                            ));

                                            request.fields['separate_item[$i][name]'] = name.toString();
                                            request.fields['separate_item[$i][price]'] = price.toString();
                                          }

                                          // request.fields['separate_item[$i][image]'] = '';
                                        }
                                      }
                                      if(DatesOfCal.isNotEmpty){
                                        request.fields['dates[]'] =
                                            DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '');
                                        // DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '')
                                      }
                                      if (isChecked2) {request.fields['everyday'] ="1";}
                                      else{request.fields['everyday'] ="0";}
                                      // try {
                                      var response = await request.send();

                                      if (response.statusCode == 302) {
                                        // Handle redirection
                                        var redirectUrl =
                                        response.headers['location'];
                                        if (redirectUrl != null) {
                                          // Make another request to the new location
                                          var redirectResponse = await http
                                              .get(Uri.parse(redirectUrl));
                                          print(
                                              'Redirected response status code-->: ${redirectResponse.statusCode}');
                                          log('Redirected response status code-->: ${redirectResponse.headers}');
                                          log('Redirected response status code-->: ${redirectResponse.body}');
                                          print(
                                              'Redirection URL not found in headers');
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else if (response.statusCode == 200) {
                                        var res = await http.Response.fromStream(
                                            response);
                                        print(res.body);
                                        final result = jsonDecode(res.body)
                                        as Map<String, dynamic>;
                                        Wid_Con.toastmsgg(context: context,msg:'Your food is Added');
                                        setState(() {
                                          isLoading = false;
                                        });
                                        print(
                                            'Food Updated successfully --> ${response.statusCode}');
                                        /* print(
                                          'Image uploaded successfully --> ${response.stream}');*/
                                        print(
                                            'Food Updated successfully --> ${result}');
                                        Navigator.pushReplacement(
                                            context,
                                            NoBlinkPageRoute(
                                                builder: (context) =>
                                                const bottom_screen(
                                                  pageindex: 1,
                                                )));
                                      } else if (response.statusCode == 400||response.statusCode == 401) {
                                        Navigator.of(context).pushReplacement(
                                          NoBlinkPageRoute(
                                            builder: (context) => const start_screen(),
                                          ),
                                        );
                                        storage.remove('email_verified');
                                        storage.remove('api_token_login');
                                      } else {
                                        var res = await http.Response.fromStream(
                                            response);
                                        final result = jsonDecode(res.body)
                                        as Map<String, dynamic>;
                                        if (result['success'] == false) {

                                          // Fluttertoast.showToast(
                                          //   msg: result['message'].toString().contains('[')?result['message'][0].toString():result['message'].toString(),
                                          //   fontSize: 16,
                                          //   backgroundColor: black,
                                          //   gravity: ToastGravity.BOTTOM,
                                          //   textColor: white,
                                          // );
                                          Wid_Con.toastmsgr(context: context,msg: result['message'].toString().contains('[')?result['message'][0].toString():result['message'].toString(),);
                                        }
                                        print(
                                            'Failed to upload image. Status code:3 ${response.statusCode}');

                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                    else {
                                      // =========================================== EDIT ==============================================================
                                      List<String> AsDate = [];
                                      print('----------date----------> $DatesOfCal');
                                      setState(() {
                                        EditDate.forEach((e) {
                                          AsDate.add(DateFormat('dd-MM-yyyy').format(e));
                                        });
                                      });
                                      print('----------date----------> $AsDate');
                                      final url =
                                          '${Url}foods-update/${widget.id}';

                                      print(
                                          '-----category_id---> ${selectedCtsIDs} null');
                                      print('-----type---> ${selectedValue}');
                                      print('-----name---> ${foodName.text}');
                                      print('-----discountcontroller---> ${discountcontroller.text}');
                                      print(
                                          '-----price---> ${price2controller.text}');
                                      print('-----Description---> $Description');
                                      print('-----TimeSlote---> ${TimeSlote}');
                                      print('-----image---> ${_image}');
                                      // print(
                                      //     '-----individualDetails---> ${individualDetails}');

                                      var request = http.MultipartRequest(
                                          'POST', Uri.parse(url))
                                        ..headers.addAll(
                                          {
                                            "Authorization":
                                            "Bearer ${storage.read('api_token_login')}"
                                          },
                                        );
                                      if (_image != null) {
                                        print(
                                            '-------------chang image----------> ');
                                        var stream = http.ByteStream(
                                            Stream.castFrom(_image!.openRead()));
                                        var length = await _image!.length();
                                        // print('---->step 3 $stream');
                                        // print('---->step 3 $length');
                                        request.files.add(http.MultipartFile(
                                          'image',
                                          stream,
                                          length,
                                          filename: path.basename(_image!.path),
                                        ));
                                      }
                                      if (selectedCtsIDs.isNotEmpty) {

                                        request.fields['category_id'] =
                                            selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
                                        print('--------selectedCtsIDs--S4---${selectedCtsIDs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}--------->');
                                      }
                                      if (selecteOptionID!=null) {
                                        request.fields['cuisine_id'] =
                                            selecteOptionID.toString();
                                      }
                                      if (selectedValue!=null) {
                                        print('--------selectedValue--isEmpty------------>');
                                        request.fields['type'] =
                                            selectedValue.toString();
                                      }
                                      if (foodName.text.isNotEmpty) {
                                        print('--------foodName--isEmpty------------>');
                                        request.fields['name'] =
                                            foodName.text.toString();
                                      }
                                      if (discountcontroller.text.isNotEmpty) {
                                        print('--------price2controller--isNotEmpty------------>');
                                        request.fields['food_preparation_time'] =
                                            discountcontroller.text;
                                      }
                                      if (price2controller.text.isNotEmpty) {
                                        print('--------price2controller--isEmpty------------>');
                                        request.fields['price'] =
                                            price2controller.text;
                                      }
                                      if (descriptionController.text.isNotEmpty) {
                                        print('--------Description--isEmpty------------>');
                                        request.fields['description'] =
                                            descriptionController.text.toString();
                                      }
                                      if (standardController.text.isNotEmpty) {
                                        print('--------standards--isNotEmpty------------>');
                                        request.fields['standards'] =
                                            standardController.text.toString();
                                      }
                                      print('--signature 4---> $signaturefood');
                                      request.fields['is_signature_food'] =
                                      signaturefood==false?'0':'1';
                                      // print('---------------time------> ${TimeSlote.toString()}');
                                      // if(TimeSlote['from'].toString()!='null'){
                                      //   request.fields['time_slots[from]'] =
                                      //       TimeSlote['from'].toString();
                                      // }
                                      // if(TimeSlote['to'].toString()!='null'){
                                      //   request.fields['time_slots[to]'] =
                                      //       TimeSlote['to'].toString();
                                      // }

                                      if (extraItems.isNotEmpty) {
                                        for (int i = 0; i < extraItems.length; i++) {
                                          print('--------index------> $i');

                                          var name = extraItems[i].name;
                                          var price = extraItems[i].price;
                                          File image = File(extraItems[i].images);

                                          if (extraItems[i]
                                              .images
                                              .contains('https')) {
                                            Uri uri =
                                            Uri.parse(extraItems[i].images);
                                            String path = uri.path;

                                            List<String> pathComponents =
                                            path.split('/');

                                            // Extract the desired path components
                                            int startIndex = pathComponents
                                                .lastIndexOf('public');
                                            String? httpImage;
                                            if (startIndex != -1) {
                                              List<String> desiredPathComponents =
                                              pathComponents
                                                  .sublist(startIndex);
                                              httpImage =
                                                  desiredPathComponents.join('/');

                                              print("Separated path: $httpImage");
                                            } else {
                                              print(
                                                  "Path doesn't contain 'public'");
                                            }

                                            request.fields[
                                            'separate_item[$i][image]'] =
                                                httpImage.toString();
                                            request.fields[
                                            'separate_item[$i][name]'] =
                                                name.toString();
                                            request.fields[
                                            'separate_item[$i][price]'] =
                                                price.toString();
                                          } else {
                                            if(isChecked == true &&(extraItems[i].name!=''||extraItems[i].price!=''||extraItems[i].images.isNotEmpty)){
                                              var fileStreamIND = http.ByteStream(
                                                  Stream.castFrom(
                                                      image.openRead()));
                                              var lengthIND = await image.length();

                                              request.files.add(http.MultipartFile(
                                                'separate_item[$i][image]',
                                                fileStreamIND,
                                                lengthIND,
                                                filename: path.basename(image.path),
                                              ));
                                              request.fields[
                                              'separate_item[$i][name]'] =
                                                  name.toString();
                                              request.fields[
                                              'separate_item[$i][price]'] =
                                                  price.toString();
                                            }
                                          }
                                        }
                                      }

                                      if(isDate==true){
                                        request.fields['dates[]'] =
                                            DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '');
                                        // DatesOfCal.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '')
                                      }else{
                                        request.fields['dates[]'] =
                                            AsDate.toSet().toList().toString().replaceAll('[', '').replaceAll(']', '');
                                      }
                                      if (isChecked2) {request.fields['everyday'] ="1";}
                                      else{request.fields['everyday'] ="0";}
                                      // try {
                                      var response = await request.send();
                                      print('-------------response.code-----------> ${response.statusCode}');

                                      if (response.statusCode == 302) {
                                        // Handle redirection
                                        var redirectUrl =
                                        response.headers['location'];
                                        if (redirectUrl != null) {
                                          // Make another request to the new location
                                          var redirectResponse = await http
                                              .get(Uri.parse(redirectUrl));
                                          print(
                                              'Redirected response status code-->: ${redirectResponse.statusCode}');
                                          log('Redirected response status code-->: ${redirectResponse.headers}');
                                          log('Redirected response status code-->: ${redirectResponse.body}');
                                          print(
                                              'Redirection URL not found in headers');
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else if (response.statusCode == 200) {
                                        var res = await http.Response.fromStream(
                                            response);
                                        final result = jsonDecode(res.body)
                                        as Map<String, dynamic>;
                                        // return !result['hasErrors'];
                                        // Fluttertoast.showToast(
                                        //   msg: 'Your food is updated',
                                        //   fontSize: 16,
                                        //   backgroundColor: black,
                                        //   gravity: ToastGravity.BOTTOM,
                                        //   textColor: white,
                                        // );
                                        Wid_Con.toastmsgg(context: context,msg:'Your food is updated',);
                                        Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> bottom_screen(pageindex: 1,)));
                                        setState(() {
                                          isLoading = false;
                                        });
                                        print(
                                            'Food Updated successfully --> ${response.statusCode}');
                                        print(
                                            'Food Updated successfully --> ${response.stream}');
                                        print(
                                            'Food Updated successfully --> ${result}');
                                        setState(() {
                                          isLoading = false;
                                          isDate = false;
                                        });

                                      }else if (response.statusCode == 400||response.statusCode == 401) {
                                        Navigator.of(context).pushReplacement(
                                          NoBlinkPageRoute(
                                            builder: (context) => const start_screen(),
                                          ),
                                        );
                                        storage.remove('email_verified');
                                        storage.remove('api_token_login');
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        var res = await http.Response.fromStream(
                                            response);
                                        final result = jsonDecode(res.body)
                                        as Map<String, dynamic>;
                                        if (result['success'] == false) {
                                          String transformedString =
                                          result['message']
                                              .map((item) => '"$item",\n')
                                              .join();

                                          // Fluttertoast.showToast(
                                          //   msg: result['message'][0].toString(),
                                          //   fontSize: 16,
                                          //   backgroundColor: black,
                                          //   gravity: ToastGravity.BOTTOM,
                                          //   textColor: white,
                                          // );
                                          Wid_Con.toastmsgr(context: context,msg:result['message'][0].toString(),);

                                          print(
                                              'Failed to upload image. Body:4 ${result}');
                                        }
                                        print(
                                            'Failed to upload image. Status code:4 ${response.statusCode}');
                                      }
                                    }
                                  }
                                },
                                width: 100,
                                height: 35,
                                titelcolor: white,
                                ButtonRadius: 5,
                                fontSize: 12,
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen(pageindex: 1,)));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: blue),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 14, color: blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: blue,
                  )),
          ),
        ),
      ),
    );
  }
}
