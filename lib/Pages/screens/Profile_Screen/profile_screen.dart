import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:comeeathome/Constants/App_Colors.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/Dialog/cuisineDialog.dart';
import '../../../Constants/Widget.dart';
import '../../test.dart';
import '../Add_DIscount/add_discount.dart';
import '../Dashboard_screen/banner_image.dart';
import '../Login_Screen/Login_Screen.dart';
import '../Orders_Screen/Orders_Screen.dart';
import '../Payout_Screen/payoutDetails_screen.dart';
import '../Review_Screen/Review_screen.dart';
import '../Service/Front_camera.dart';
import '../Login_Screen/Start_Screen.dart';
import '../Service/Privacy_policy.dart';
import '../bottombar_screen.dart';

class profile_screen extends StatefulWidget {
  const profile_screen({Key? key}) : super(key: key);

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  bool isedited_bankdetails = false;
  var parsedstringDescription;
  var parsedstringInformation;
  var parsedstringBiography;
  // String selected_coutry = "";
  String selecteOption = '';
  String textdata = '';
  String User_networkimage = '';
  String Kitchen_networkimage = '';
  String Gst_networkimage = '';
  String FSSAI_networkimage = '';
  String infra_networkimage = '';
  String building_networkimage = '';
  List certiValue = [];
  List<String> selectedCertificateValue = [];
  List<int> CuisinesID = [];
  bool isLoading = true;
  bool user_active = false;
  bool mapshow = false;
  bool select_curr_location = false;
  String documntName="";
  String phoneNumber = "";
  List<String> gstoption = ["5 %"];
  // String mobileNumber = "";
  String kitchen_phone = "";
  File? PickDocuments;
  File? avatar_image;
  CroppedFile? _croppedFile;
  File? image;
  File? imageinfra;
  File? imagebuilding;
  File? gstphoto;
  File? fssaiphoto;
  var description;
  var information;
  bool fetchcurrent =false;
  bool? document_size = false;
  final picker = ImagePicker();
  String address = '';
  String Latitude = '';
  String Langitude = '';
  double current_long  = 1.0;
  double current_lat  = 1.0;

  bool isChecked = false;
  bool isCheck = false;
  List cuisine = [];
  List cuisinesData = [];
  String cuisineselecteOption = '';
  int? selecteOptionID;
  String selectedOption = '';
  var kitchen = {};
  TextEditingController kitchennamecontroller = TextEditingController();
  TextEditingController kitchenVatcontroller = TextEditingController();
  TextEditingController kitchenFSSAIcontroller = TextEditingController();
  TextEditingController kitchenphonecontroller = TextEditingController();
  TextEditingController kitchenMobilecontroller = TextEditingController();
  TextEditingController kitchenAddresscontroller = TextEditingController();
  TextEditingController kitchenPinCodecontroller = TextEditingController();
  TextEditingController kitchenLatitudecontroller = TextEditingController();
  TextEditingController kitchenLongitudecontroller = TextEditingController();
  TextEditingController kitchenSlotscontroller = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController BiographyController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController InformationController = TextEditingController();
  TextEditingController cuisines = TextEditingController();
  TextEditingController gstoptionn = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  TextEditingController dinnerDineInController = TextEditingController();
  TextEditingController snacksDineInController = TextEditingController();
  TextEditingController lunchDineInController = TextEditingController();
  TextEditingController nuofdelivaryController = TextEditingController();
  TextEditingController breakfastDineInController = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasscontroller = TextEditingController();
  TextEditingController userphonecontroller = TextEditingController();
  TextEditingController useraddresscontroller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final customToolBarList = [];
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = <Marker>[];
  FocusNode focusNode = FocusNode();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  final kitchenstatus = ValueNotifier<bool>(false);
  var cityName;
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  bool _showGoogleMapInContainer = false;

  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";



  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor



  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4,
  );

  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(
            title: 'some Info '
        )
    ),
  ];



  Future<void> openImagePickerCamera() async {

    List<CameraDescription> cameras = await availableCameras();
    Navigator.push(context, NoBlinkPageRoute(builder: (context)=>CameraScreen(cameras: cameras, onPictureTaken: onPictureTaken,)));
  }
  Future<void> openImagePicker() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {

      int maxSizeInBytes = 10 * 1024 * 1024; // 2 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          image =   File(pickedImage.path);
        });

      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }
    }
  }
  Future<void> openImagePickerCameraKitchen() async {
      final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 2 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {

        // final croppedFile = await ImageCropper().cropImage(sourcePath: pickedImage.path, compressFormat: ImageCompressFormat.jpg, compressQuality: 100,
        //   aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        //   uiSettings: [ IOSUiSettings(title: ''),AndroidUiSettings(toolbarTitle: '',toolbarColor: Colors.black, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: true),],);
        //
        // if (croppedFile != null) {
        //   setState(() {
        //     image =   File(croppedFile.path);
        //   });
        // }
        setState(() {
          image =  File(pickedImage.path);
        });

      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }

    }
    //List<CameraDescription> cameras = await availableCameras();
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraScreen(cameras: cameras, onPictureTaken: onPictureTaken,)));
  }
  Future<void> openImagePickerinfra() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 2 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {

        // final croppedFile = await ImageCropper().cropImage(sourcePath: pickedImage.path, compressFormat: ImageCompressFormat.jpg, compressQuality: 100,
        //     aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        //   uiSettings: [ IOSUiSettings(title: ''),AndroidUiSettings(toolbarTitle: '',toolbarColor: Colors.black, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: true),],);
        //
        // if (croppedFile != null) {
        //   setState(() {
        //     imageinfra =   File(croppedFile.path);
        //   });
        // }
        setState(() {
          imageinfra =  File(pickedImage.path);
        });
      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }

    }
  }
  Future<void> openImagePickerCamerainfra() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 2 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          imageinfra =   File(pickedImage.path);
        });
      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }
    }
  }
  Future<void> openImagePickerbuilding() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          imagebuilding =   File(pickedImage.path);
        });
      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }

    }
  }
  Future<void> openImagePickerCamerabuilding() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 2 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          imagebuilding =   File(pickedImage.path);
        });
      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }
    }
  }
  Future<void> openImagePickergallerygst() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          gstphoto =   File(pickedImage.path);
        });

      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }

    }
  }
  Future<void> openImagePickerCameragst() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          gstphoto =   File(pickedImage.path);
        });
      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }

    }
  }
  Future<void> openImagePickergalleryfssai() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {

        setState(() {
          fssaiphoto =   File(pickedImage.path);
        });

      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }

    }
  }
  Future<void> openImagePickerCamerafssai() async {
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      int maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length;
      if (fileSize <= maxSizeInBytes) {
        setState(() {
          fssaiphoto =   File(pickedImage.path);
        });
      } else {
        Wid_Con.toastmsgr(context: context,msg:"Image size exceeds the limit (10 MB)");
      }
    }
  }


  void getKitchen_verify() async {

    const url = '${Url}details';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );
    final data = json.decode(response.body);



    log('-kitchen response--> ${response.body}');
    print(data);

    if(response.statusCode==200||response.statusCode==201) {

      if (data['success'] == true) {
        // iskitchenDetail = false;
        print(data['data']['active']);
        if (data['data']['active'] == false) {
          storage.write('isActive', false);
        } else {
          setState(() {
            user_active=true;
          });
          storage.write('isActive', true);
        }
        storage.write('IsKitchen', false);

        setState(() {
          kitchen = data['data'];

          if (kitchen.isNotEmpty) {

            kitchenstatus.value = kitchen['closed']=='1'?false:true;
            cityName = kitchen['city'];
            print('----kitchenstatus------- > ${cityName}');
            kitchennamecontroller = TextEditingController(text: '${kitchen['name']}');
            kitchenphonecontroller = TextEditingController(text: '${kitchen['phone'] ?? ''}');
            kitchen_phone = kitchen['phone'] ?? '';
            // phoneNumber
              kitchenMobilecontroller.text = kitchen['mobile'].toString() ?? '';

            kitchenPinCodecontroller.text = kitchen['pincode']??'';
            kitchenVatcontroller.text = kitchen['vat']??'';
            breakfastDineInController.text = kitchen['breakfastslots']??'';
            lunchDineInController.text = kitchen['lunchslots']??'';
            snacksDineInController.text = kitchen['snacksslots']??'';
            dinnerDineInController.text = kitchen['dinnerslots']??'';
            kitchenMobilecontroller = TextEditingController(text: '${kitchen['mobile'] ?? ''}');
            kitchenVatcontroller = TextEditingController(text: '${kitchen['gst_number'] ?? ''}');
            kitchenFSSAIcontroller = TextEditingController(text: '${kitchen['fssai_number'] ?? ''}');
            kitchenAddresscontroller = TextEditingController(text: '${kitchen['address']?? ''}');
            kitchenLatitudecontroller = TextEditingController(text: '${kitchen['latitude']?? ''}');
            kitchenLongitudecontroller = TextEditingController(text: '${kitchen['longitude']?? ''}');
            kitchenSlotscontroller = TextEditingController(text: '${kitchen['slots']?? ''}');
            nuofdelivaryController = TextEditingController(text: '${kitchen['number_of_delivery'] ?? ''}');
            DescriptionController.text = kitchen['description'] ?? '';
            print('---------description--------- ${description}');
            InformationController.text = kitchen['information'] ?? '';
            // isChecked = kitchen['closed'];
            isCheck = kitchen['available_for_delivery'];
            isedited_bankdetails = kitchen["beneficiary_id"] == "" ? false : true;
            if (kitchen['media'].isNotEmpty) {
              print(
                  '---------isNotEmpty--------- ${kitchen['media'][0]['thumb']}');
              Kitchen_networkimage = kitchen['media'][0]['thumb'];
              kitchen['gst_photo']!=null? Gst_networkimage = kitchen['gst_photo']:Gst_networkimage="";
              kitchen['fssai_photo']!=null? FSSAI_networkimage = kitchen['fssai_photo']:FSSAI_networkimage="";
              kitchen['infrastructure_image']!=null?infra_networkimage = kitchen['infrastructure_image']:infra_networkimage="";
              kitchen['main_building_image']!=null? building_networkimage = kitchen['main_building_image']:building_networkimage="";


              //print('---------------Gst_networkimage-------> ${kitchen['gst_photo']}');

            } else {
              Kitchen_networkimage = 'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg';
              Gst_networkimage = 'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg';
              FSSAI_networkimage = 'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg';
              infra_networkimage = 'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg';
              building_networkimage = 'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg';
            }
            // selectedCertificateValue
            print('---------------cuisines-------> ');
            if (kitchen['cuisines'] != [] ||
                kitchen['cuisines'].isNotEmpty ||
                kitchen['cuisines'] != null) {
              kitchen['cuisines'].forEach((e) {
                selectedCertificateValue.add(e['name']);
                CuisinesID.add(e['id']);
                print('---------------cuisines-------> ${e['name']}');
              });
            }

            if (kitchen['documents'] != null ||
                kitchen['documents'] != '') {
              Uri uri =
              Uri.parse(kitchen['documents']);
              String path = uri.path;

              List<String> pathComponents =
              path.split('/');

              // Extract the desired path components
              int startIndex = pathComponents
                  .lastIndexOf('kitchen-documents');

              if (startIndex != -1) {
                List<String> desiredPathComponents =
                pathComponents
                    .sublist(startIndex);
                documntName =
                    desiredPathComponents.join('/');
              }
            }
            setState(() {
              isLoading = false;
            });
          }else{
            kitchenMobilecontroller.text = phoneNumber;
          }
        });

        setState(() {
          isLoading = false;
        });

      } else {

        storage.write('IsKitchen', true);
        storage.write('isActive', false);
        String errorMessage = data['message'];
        print('error :-> $errorMessage');
        setState(() {
          isLoading = false;
          kitchenMobilecontroller.text = phoneNumber;
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
      setState(() {
        isLoading = false;
      });
    }

  }

  LatLng? currentPostion;

getlatlon() async {
  await Geolocator.requestPermission();
  var position = await GeolocatorPlatform.instance
      .getCurrentPosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  final add = placemarks.first;

  setState(() {
    currentPostion = LatLng(position.latitude, position.longitude);

    address = "${add.street}, ${add.name}, ${add.locality}, ${add.administrativeArea}, ${add.country} - ${add.postalCode}";
    kitchenAddresscontroller.text = address;
    kitchenPinCodecontroller.text = add.postalCode.toString();
    kitchenLatitudecontroller.text = currentPostion!.latitude.toString();
    kitchenLongitudecontroller.text = currentPostion!.longitude.toString();
    cityName = add.locality.toString();
    print('--pincode---> ${kitchenPinCodecontroller.text}');
    print('--latitude---> ${kitchenLatitudecontroller.text}');
    print('--longitude---> ${kitchenLongitudecontroller.text}');
    print('--city---> ${cityName}');

  });
  setState(() {



    // cityName
    // kitchenAddresscontroller.text
  });
}
  @override
  void initState() {
    _markers.addAll(list);

    if(user_active==false &&  storage.read('IsKitchen') == true ){
      getlatlon();
    }
    getuserdetails();
    getKitchen_verify();

    cuisineList();

   // _getUserCurrentLocation();

    // Future.delayed(Duration(seconds: 3), () {
    //   // After 3 seconds, turn off the loader
    //
    // });
    super.initState();

  }

  Future<void> onPictureTaken(XFile picture) async {
    // Handle the captured image (e.g., display it, save it, etc.)
    print('Captured image path: ${picture.path}');
    final croppedFile = await ImageCropper().cropImage(sourcePath: picture.path, compressFormat: ImageCompressFormat.jpg, compressQuality: 100,aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [AndroidUiSettings(toolbarTitle: '',toolbarColor: Colors.black, toolbarWidgetColor: Colors.white,lockAspectRatio: true),],);

    if (croppedFile != null) {
      setState(() {
        avatar_image = File(croppedFile.path);
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    print('---->step 1');
    try {
      print('---->step 2');

      const url = '${Url}settings';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'api_token': storage.read('api_token_login'),
        },
      );
      print('${response.body}');
      print('---->step 3');

      print('---->step 4');
      final data = json.decode(response.body);
      print('---->step 5');

      if(response.statusCode==200||response.statusCode==201) {
        if (data['success'] == true) {
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
  Future<void> cuisineList() async {
    cuisine.clear();
    try {
      const url = 'https://eatathome.in/app/api/cuisines';

      final response = await http.get(
        Uri.parse(url),
      );

      final data = json.decode(response.body);

      if(response.statusCode==200||response.statusCode==201) {
        if (data['success'] == true) {
          setState(() {
            cuisine.addAll(data['data']);
            // for (var item in data['data']) {
            //   cuisine.add(item['name']);
            // }
          });

          // log('-----cuisine--------> $cuisine');
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
  Future<void> kitchenOpen({String? isKitchenid}) async {
    cuisine.clear();
    try {
      final response = await http.post(
        Uri.parse("${Url}kitchen-open"),
        body: {
          'closed': isKitchenid,
        },
        headers: {
          'Authorization': 'Bearer ${storage.read('api_token_login')}',
        },
      );
      cuisineList();
      final data = json.decode(response.body);

     // log('----isKitchenOpen------> ${response.body}');
      Navigator.pop(context,true);
    } catch (e) {
      // Handle other error scenarios like network issues or unexpected responses
      log('Errorrrr: $e');
    }
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    // BiographyController.dispose();
    // DescriptionController.dispose();
    // InformationController.dispose();0
   // _controller_.dispose();
    super.dispose();
  }


  var userdetails;

  void getuserdetails() async {
    print('step 1--> ${storage.read('api_token_login')}');
    // try {
    print('step 2');

    var url = '${Url}user?api_token=${storage.read('api_token_login')}';
    print(url);
    // setState(() {
    //   isLoading = true;
    // });
    final response = await http.get(
      Uri.parse('${Url}user?api_token=${storage.read('api_token_login')}'),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );

    print('step 3');

    final data = json.decode(response.body);
    log('step 4--------> ${response.body}');
    log('step 4--------> ${response.statusCode}');

    if(response.statusCode==200||response.statusCode==201) {
      if (data['success'] == true) {
        setState(() {
          userdetails = data['data'];
          print(userdetails);
          print('step 5');
          // log('-------$userdetails');

          usernamecontroller = TextEditingController(text: '${userdetails['name']}');
          useremailcontroller = TextEditingController(text: '${userdetails['email']}');
          print('---------is--------- ${userdetails['name']}');
          userpasscontroller = TextEditingController(text: '');
          // userphonecontroller = TextEditingController(
          //     text: userdetails['custom_fields'].isNotEmpty
          //         ? '${ PhoneNumber.fromCompleteNumber(completeNumber: userdetails['custom_fields']['phone']['value']).number}'
          //         : '');
          phoneNumber = userdetails['custom_fields'].isNotEmpty
              ? '${userdetails['custom_fields']['phone']['value'] ?? ''}'
              : '';
          // kitchenMobilecontroller.text.isEmpty?
          // kitchenMobilecontroller.text = userdetails['custom_fields'].isNotEmpty
          //     ? '${userdetails['custom_fields']['phone']['value'] ?? ''}'
          //     : '':null;
          // selected_coutry = userdetails['custom_fields'].isNotEmpty
          //     ? PhoneNumber.getCountry( '${userdetails['custom_fields']['phone']['value'] ?? ''}').code.toString()
          //     : '';
          BiographyController = TextEditingController(
              text: userdetails['custom_fields'].isNotEmpty
                  ? '${userdetails['custom_fields']['bio']['value'] ?? ''}'
                  : '');
          useraddresscontroller = TextEditingController(
              text: userdetails['custom_fields'].isNotEmpty
                  ? '${userdetails['custom_fields']['address']['value'] ?? ''}'
                  : '');

            cardNumberController.text = userdetails['bank_account_id']??'';
            expiryDateController.text = userdetails['bank_name']??'';
            cvvController.text = userdetails['bank_ifsc']??'';
            cardHolderNameController.text = userdetails['bank_customer_name']??'';


          // print('---------is--------- ${userdetails[0]['media']}');
          if (userdetails['media'].isNotEmpty) {
            // print('---------isNotEmpty--------- ${userdetails['media']}');///
            User_networkimage = userdetails['media'][0]['thumb'];
          //  print('---------User_networkimage--------- ${userdetails['media']['thumb']}');
          } else {
            // print('---------isEmpty---------');.
            User_networkimage = 'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg';
          }


        });

        // date = DateTime.parse(notification[0][index]['user_name']);
        // dateformat = DateFormat('MMM d, yyyy h:mm').format(date!);
        // setState(() {
        //   isLoading = false;
        // });
      } else {
        // setState(() {
        //   isLoading = false;
        // });
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

    // } catch (e) {
    //   // Handle other error scenarios like network issues or unexpected responses
    //   log('Errorrrr: $e');
    // }
  }

  void kitchen_Details({
    String? isOpen,
    String? name,
    String? gst_number,
    String? fssai_number,
    String? number_of_delivery,
    String? description,
    String? address,
    String? latitude,
    String? longitude,
    String? slots,
    String? phone,
    String? mobile,
    String? information,
    String? userName,
    String? userEmail,
    String? userpassword,
    String? userphone,
    String? userbio,
    String? useraddress,
    File? useravatar,
    File? kitchenimage,
    File? gst_photo,
    File? fssai_photo,
    File? infrastructure_image,
    File? main_building_image,
    // String? closed,
    String? availableFordelivery,
    String? card_number,
    String? cvv,
    String? expiry_date,
    String? holder_name,
    String? pincode,
    String? vat,
    String? breakfastslots,
    String? lunchslots,
    String? snacksslots,
    String? city,
    String? dinnerslots,
    var cuisinesid,
    File? Documents,
  }) async {
    var result;
    setState(() {
      isLoading = true;
    });

    const url = '${Url}details-change';
    print('----> $url');
    print('----> $name');

    var request = http.MultipartRequest(
        'POST', Uri.parse(url))
      ..headers.addAll(
        {
          "Authorization":
          "Bearer ${storage.read('api_token_login')}"
        },
      );

    if (useravatar != null) {
      print('-------------chang image----------> ');
      var stream = http.ByteStream(
          Stream.castFrom(useravatar.openRead()));
      var length = await useravatar.length();
      print('---->step 3 $stream');
      print('---->step 3 $length');
      request.files.add(http.MultipartFile(
        'users[avatar]',
        stream,
        length,
        filename: path.basename(useravatar.path),
      ));
    } else {
      print('-------------network image----------> $User_networkimage');
      Uri uri = Uri.parse(User_networkimage);
      String path = uri.path;

      List<String> pathComponents = path.split('/');

      // Extract the desired path components
      int startIndex = pathComponents.lastIndexOf('public');
      String? httpImage;
      if (startIndex != -1) {
        List<String> desiredPathComponents = pathComponents.sublist(startIndex);
        httpImage = desiredPathComponents.join('/');

        print("Separated path: $httpImage");
      } else {
        print("Path doesn't contain 'public'");
      }
      request.fields['users[avatar]'] = httpImage.toString();
    }

    if (kitchenimage != null) {

      var stream = http.ByteStream(Stream.castFrom(kitchenimage.openRead()));
      var length = await kitchenimage.length();
      request.files.add(http.MultipartFile('image', stream, length, filename: path.basename(kitchenimage.path),));

    }
    else {

      Uri uri = Uri.parse(Kitchen_networkimage);
      String path = uri.path;
      List<String> pathComponents = path.split('/');
      int startIndex = pathComponents.lastIndexOf('public');
      String? httpImage;
      if (startIndex != -1) {
        List<String> desiredPathComponents = pathComponents.sublist(startIndex);
        httpImage = desiredPathComponents.join('/');
      }
      else {print("Path doesn't contain 'public'");}
      request.fields['image'] = httpImage.toString();

    }

    if (gst_photo != null) {

      var stream = http.ByteStream(Stream.castFrom(gst_photo.openRead()));
      var length = await gst_photo.length();
      request.files.add(http.MultipartFile('gst_photo', stream, length, filename: path.basename(gst_photo.path),));

    }
    else {
      Uri uri = Uri.parse(Gst_networkimage);
      String path = uri.path;
      List<String> pathComponents = path.split('/');
      int startIndex = pathComponents.lastIndexOf('public');
      String? httpImage;
      if (startIndex != -1) {
        List<String> desiredPathComponents = pathComponents.sublist(startIndex);
        httpImage = desiredPathComponents.join('/');
      }
      else {print("Path doesn't contain 'public'");}
      request.fields['gst_photo'] = httpImage.toString();

    }

    if (fssai_photo != null) {

      var stream = http.ByteStream(Stream.castFrom(fssai_photo.openRead()));
      var length = await fssai_photo.length();
      request.files.add(http.MultipartFile('fssai_photo', stream, length, filename: path.basename(fssai_photo.path),));

    }
    else {

      Uri uri = Uri.parse(FSSAI_networkimage);
      String path = uri.path;
      List<String> pathComponents = path.split('/');
      int startIndex = pathComponents.lastIndexOf('public');
      String? httpImage;
      if (startIndex != -1) {
        List<String> desiredPathComponents = pathComponents.sublist(startIndex);
        httpImage = desiredPathComponents.join('/');
      }
      else {print("Path doesn't contain 'public'");}
      request.fields['fssai_photo'] = httpImage.toString();

    }

    if (infrastructure_image != null) {

      var stream = http.ByteStream(Stream.castFrom(infrastructure_image.openRead()));
      var length = await infrastructure_image.length();
      request.files.add(http.MultipartFile('infrastructure_image', stream, length, filename: path.basename(infrastructure_image.path),));

    }
    else {

      Uri uri = Uri.parse(infra_networkimage);
      String path = uri.path;
      List<String> pathComponents = path.split('/');
      int startIndex = pathComponents.lastIndexOf('public');
      String? httpImage;
      if (startIndex != -1) {
        List<String> desiredPathComponents = pathComponents.sublist(startIndex);
        httpImage = desiredPathComponents.join('/');
      }
      else {print("Path doesn't contain 'public'");}
      request.fields['infrastructure_image'] = httpImage.toString();

    }

    if (main_building_image != null) {

      var stream = http.ByteStream(Stream.castFrom(main_building_image.openRead()));
      var length = await main_building_image.length();
      request.files.add(http.MultipartFile('main_building_image', stream, length, filename: path.basename(main_building_image.path),));

    }
    else {

      Uri uri = Uri.parse(building_networkimage);
      String path = uri.path;
      List<String> pathComponents = path.split('/');
      int startIndex = pathComponents.lastIndexOf('public');
      String? httpImage;
      if (startIndex != -1) {
        List<String> desiredPathComponents = pathComponents.sublist(startIndex);
        httpImage = desiredPathComponents.join('/');
      }
      else {print("Path doesn't contain 'public'");}
      request.fields['main_building_image'] = httpImage.toString();

    }


    if (Documents != null) {
      print('-------------Document----------> ');
      print('---->step 3 ${Documents.readAsBytes().asStream()}');
      print('---->step 3 ${Documents.lengthSync()}');
      request.files.add(http.MultipartFile(
        'documents',
        Documents.readAsBytes().asStream(),
        Documents.lengthSync(),
        filename: path.basename(Documents.path),
      ));
    }
    else
      {
        request.fields['documents'] = documntName;
      }
    if (name
        .toString()
        .isNotEmpty) {
      request.fields['name'] = name ?? '';

    }
    print('------------item-------------> 1 $cuisinesid');
    if (cuisinesid != null) {
      for (int item in cuisinesid) {
        print('------------item-------------> 2 $item');
        request.files.add(
            http.MultipartFile.fromString('cuisine_id[]', item.toString()));
      }
    }
    if (address
        .toString()
        .isNotEmpty) {
      request.fields['address'] = address ?? '';
    }
    if (description
        .toString()
        .isNotEmpty) {
      request.fields['description'] = description ?? '';
    }
    if (latitude
        .toString()
        .isNotEmpty) {
      request.fields['latitude'] = latitude ?? '';
    }
    if (longitude
        .toString()
        .isNotEmpty) {
      request.fields['longitude'] = longitude ?? '';
    }
    if (slots
        .toString()
        .isNotEmpty) {
      request.fields['slots'] = slots ?? '';
    }
    print('-------------isOpen----------> $isOpen');
    request.fields['gst_number'] = gst_number ?? '';
    // request.fields['is_open'] = isOpen ?? '';
    request.fields['fssai_number'] = fssai_number ?? '';
    request.fields['number_of_delivery'] = number_of_delivery ?? '';
    request.fields['phone'] = phone ?? '';
    request.fields['pincode'] = pincode ?? '';
    request.fields['breakfastslots'] = breakfastslots ?? '';
    request.fields['lunchslots'] = lunchslots ?? '';
    request.fields['snacksslots'] = snacksslots ?? '';
    request.fields['dinnerslots'] = dinnerslots ?? '';
    request.fields['mobile'] = mobile ?? '';
    request.fields['vat'] = vat ?? '';
    request.fields['information'] = information ?? '';
    request.fields['users[name]'] = userName ?? '';
    request.fields['users[email]'] = userEmail ?? '';
    request.fields['users[password]'] = userpassword ?? '';
    request.fields['users[phone]'] = userphone ?? '';
    request.fields['users[bio]'] = userbio ?? '';
    request.fields['users[address]'] = useraddress ?? '';
    request.fields['users[bank_account_id]'] = card_number ?? '';
    request.fields['users[bank_name]'] = expiry_date ?? '';
    request.fields['users[bank_customer_name]'] = holder_name ?? '';
    request.fields['users[bank_ifsc]'] = cvv ?? '';
    request.fields['closed'] = isOpen ?? '';
    request.fields['available_for_delivery'] = availableFordelivery ?? '';
    request.fields['city'] = city ?? '';
    request.fields['is_payment_edit'] = !isedited_bankdetails ? "1" : "0";

    var response = await request.send();
    print(response.statusCode);
    log("status code.......--->>>"+response.statusCode.toString());
    log("full response--->>>"+response.toString());

    if (response.statusCode == 302) {
      // Handle redirection
      var redirectUrl =
      response.headers['location'];
      if (redirectUrl != null) {
        // Make another request to the new location
        var redirectResponse = await http
            .get(Uri.parse(redirectUrl));
        print('Redirected response status code-->: ${redirectResponse
            .statusCode}');
        log('Redirected response status code-->: ${redirectResponse.headers}');
        log('Redirected response status code-->: ${redirectResponse.body}');
        print('Redirection URL not found in headers');
        log("status 302---->>>"+response.toString());

        Wid_Con.toastmsgr(context: context,msg:result['message']);
      }
      storage.write('IsKitchen', true);
      setState(() {
        isLoading = false;
      });

    }

    else if (response.statusCode == 200) {
      var res = await http.Response.fromStream(response);
      result = jsonDecode(res.body)
      as Map<String, dynamic>;
      print(result);
      log("status 200---->>>"+res.toString());
      // return !result['hasErrors'];
      storage.write('IsKitchen', false);
      print('Image uploaded successfully --> ${response.statusCode}');
      print('Image uploaded successfully --> ${response.stream}');
      print('Image uploaded successfully --> ${result}');
      Wid_Con.toastmsgg(context: context,msg:result['message']);
      setState(() {
        isLoading = false;
      });
    }

    else if (response.statusCode == 404) {

      var res = await http.Response.fromStream(response);
      result = jsonDecode(res.body) as Map<String, dynamic>;
      log("status 404---->>>"+res.toString());
      log("status 404-result--->>>"+result.toString());
      if (result['success'] == false) {

        Wid_Con.toastmsgr(context: context,msg:result['message'][0].toString());
      }

      setState(() {
        isLoading = false;
      });
    }
  }


  // void _getUserCurrentLocation() async {
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //
  //   if(permission.name.toString() == 'denied'){
  //     await Geolocator.requestPermission();
  //   }
  //   print('------permission profile----> ${permission.name}');
  //
  //   if(permission.name == "denied"){
  //     setState(() {
  //       fetchcurrent = false;
  //       mapshow = false;
  //     });
  //   }
  // }

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        NoBlinkPageRoute(builder: (context) => const bottom_screen()))) ??
        false;
  }

      @override
      Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: isLoading == true
                ? Center(
              child: CircularProgressIndicator(color: blue),
            )
                : GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
                  child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              key: scaffoldKey,
              appBar: Wid_Con.App_Bar(
                    leading: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          scaffoldKey.currentState?.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/list.png',
                        ),
                      ),
                    ),
                    titel: 'MANAGE PROFILE',
                    fontweight: FontWeight.w600,
                     actions: [
                       SizedBox(width: 6.w,)
                    //   IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.account_circle_outlined,
                    //       color: grey,
                    //     ),
                    //   )
                     ]
              ),
              drawer: Wid_Con.drawer(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.75,
                    onPressedfav: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const Orders_Screen()));
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
                              builder: (context) =>
                              const Orders_Screen(orderdrawer: true,)));
                    },
                    onPressedreview: () {
                      Navigator.pop(context);
                      Navigator.push(context,
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
                      showDialog(
                          context: context, builder: (context) =>const add_discount());
                    },
                    onPressedlogout: () {
                      logout(context);
                    }),
              body: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        user_active==false ?  storage.read('IsKitchen') == true ?
                        Container(
                          height: 130,
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: redlight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kindly fill the profile details for further verification process.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: red,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ) : Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your profile is submitted to verification, appreciate your patience.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ):Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w400),
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Center(
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Avatar*',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: bluefont,
                                                      fontFamily: fontfamily,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                const SizedBox(width: 5),
                                                const ElTooltip(
                                                  child: Icon(Icons.info_outline, size: 17,),
                                                  content: Text('1:1 Aspect Ratio Required.'),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Center(
                                            child: Container(
                                              height: 20.h,
                                              width: 20.h,
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: grey300, width: 0.7),
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: avatar_image != null
                                                  ? GestureDetector(
                                                onTap: () {
                                                  openImagePickerCamera();
                                                },
                                                child:ClipOval(
                                                  child: Image.file(
                                                    avatar_image!,
                                                    fit: BoxFit.cover, // Use BoxFit.cover to ensure the image covers the entire oval shape
                                                  ),
                                                ),

                                              )
                                                  : User_networkimage.isEmpty ?
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  InkWell(
                                                      child: Image.network(
                                                        'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg',

                                                        // fit: BoxFit.cover
                                                      ),
                                                      onTap: () {
                                                        openImagePickerCamera();
                                                      }),
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
                                              ) :
                                              GestureDetector(
                                                onTap: () {
                                                  openImagePickerCamera();
                                                },
                                                child: ClipOval(
                                                  child: Image.network(
                                                    User_networkimage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            'Name*',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: bluefont,
                                                fontFamily: fontfamily,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 15),
                                          Container(
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: grey,
                                                fontSize: 13,
                                                fontFamily: fontfamily,
                                              ),
                                              controller: usernamecontroller,
                                              cursorColor: grey,

                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintText: 'Insert Name',
                                                hintStyle: TextStyle(
                                                  color: grey,
                                                  fontSize: 13,
                                                  fontFamily: fontfamily,
                                                ),
                                                contentPadding: const EdgeInsets.all(8.0),
                                                // contentPadding:
                                                // const EdgeInsets.symmetric(
                                                //     horizontal: 10, vertical: 20),
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
                                          const SizedBox(height: 15),
                                          Text(
                                            'Email*',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: bluefont,
                                                fontFamily: fontfamily,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: grey,
                                                fontSize: 13,
                                                fontFamily: fontfamily,
                                              ),
                                              controller: useremailcontroller,
                                              cursorColor: grey,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintText: 'Insert Name',
                                                hintStyle: TextStyle(
                                                  color: grey,
                                                  fontSize: 13,
                                                  fontFamily: fontfamily,
                                                ),
                                                contentPadding: const EdgeInsets.all(8.0),
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
                                          const SizedBox(height: 15),
                                          Container(height: 1,width: double.infinity,color: grey200,),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                'Kitchen status',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: bluefont,
                                                    fontFamily: fontfamily,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(width: 10),
                                              AdvancedSwitch(
                                                initialValue: kitchenstatus.value,
                                                controller: kitchenstatus,
                                                activeColor: green400,
                                                inactiveColor: greyfont,
                                                activeChild: const Padding(
                                                  padding: EdgeInsets.only(left: 5),
                                                  child: Text('Open'),
                                                ),
                                                inactiveChild: const Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: Text('Close'),
                                                ),
                                                onChanged: (value) async {

                                                    showDialog(
                                                      barrierDismissible: false,
                                                    context: context, builder: (context) {
                                                      return AlertDialog(
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        titlePadding: EdgeInsets.zero,
                                                        title: Container(
                                                          padding: EdgeInsets.zero,
                                                          height: 200,
                                                          child: Stack(
                                                            children: [
                                                               SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 40,
                                                                      width: double.infinity,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 10),
                                                                        child: Center(
                                                                          child: Text(
                                                                            'Kitchen',
                                                                            style: TextStyle(fontSize: 20, color: black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(color: grey, thickness: 0.5),
                                                                    SizedBox(height: 20,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                      child: Center(
                                                                        child: Text(
                                                                          'Are you sure you want to change kitchen status?',
                                                                          // textAlign: TextAlign.center,
                                                                          style: TextStyle(fontSize: 16, color: black,fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ),
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
                                                                          ButtonName: 'CANCEL',
                                                                          bottomLeftRadius: 10,

                                                                          onPressed: () {
                                                                            setState(() {
                                                                              print('===> ${kitchenstatus.value}');
                                                                              kitchenstatus.value =! value;
                                                                              print('====> ${kitchenstatus.value}');
                                                                              Navigator.pop(context,false);
                                                                              Navigator.pop(context,false);
                                                                            });

                                                                          },
                                                                          titelcolor: white,
                                                                          fontSize: 17,
                                                                          fontWeight: FontWeight.w500),
                                                                    ),
                                                                    Expanded(
                                                                      child: Wid_Con.button(
                                                                          ButtonName: 'OK',
                                                                          bottomRightRadius: 10,
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              kitchenstatus.value = value;
                                                                            });
                                                                            kitchenOpen(isKitchenid: value==false?'1':'0');
                                                                          },

                                                                          titelcolor: white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                  },);

                                                  // kitchenOpen(isKitchenid: value==false?'0':'1');
                                                },
                                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                width: 70.0,
                                                height: 30.0,
                                                enabled: true,
                                                disabledOpacity: 0.5,
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const SizedBox(
                                  height: 15,
                                ),


                              //const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Short Biography*',
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 12,
                                          color: bluefont,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('Short Biography'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  maxLines: 5,
                                  style: TextStyle(color: grey,fontSize: 14,),
                                  controller: BiographyController,
                                  decoration: InputDecoration(
                                    // isDense: true,
                                  //    hintText: 'Short Biography',
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

                                const SizedBox(height: 20),
                                Text(
                                  'Address*',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 35,
                                  child: TextFormField(
                                    style: TextStyle(color: grey,fontSize: 13,),
                                    // maxLines: 10,
                                    controller: useraddresscontroller,
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(8.0),
                                     // contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kitchens Details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Name*',
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
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    controller: kitchennamecontroller,
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      //hintText: 'Insert Name',
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
                                      // contentPadding:
                                      // const EdgeInsets.symmetric(
                                      //     horizontal: 10, vertical: 10),
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
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'GST number',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: bluefont,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('The example of a GSTIN would go like this: 22AAAAA0000A1Z5, where 22 is the state code, which is Chattisgarh, AAAAA0000A is the PAN or the Personal Account Number, 1 is the entity number of the same PAN holder in a state, Z is the default alphabet and 5 is the checksum digit.'),showChildAboveOverlay: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 35,
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: kitchenVatcontroller,
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                //      hintText: 'Insert Vat',
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
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
                                const SizedBox(height: 10),
                                Text(
                                  'GST Photo',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: grey300, width: 0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: gstphoto != null
                                      ? GestureDetector(
                                      onTap: () {
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
                                                        Expanded(child: Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          ButtonRadius: 5,
                                                          onPressed:
                                                              () async {
                                                            openImagePickergallerygst();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          ButtonName:
                                                          'Gallery',
                                                        ),),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(child: Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          ButtonRadius: 5,
                                                          ButtonName:
                                                          'Camera',
                                                          onPressed:
                                                              () {
                                                            openImagePickerCameragst();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),)

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Image.file(
                                          gstphoto!, fit: BoxFit.fitHeight))
                                      : Gst_networkimage.isEmpty ||
                                      Gst_networkimage == '' ?
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            child: Center(
                                              child: Image.network(
                                                'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg',

                                              ),
                                            ),
                                            onTap: () {
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
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                onPressed:
                                                                    () async {
                                                                  openImagePickergallerygst();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                ButtonName:
                                                                'Gallery',
                                                                ButtonRadius: 5,
                                                              ),),

                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                ButtonName:
                                                                'Camera',
                                                                ButtonRadius: 5,
                                                                onPressed:
                                                                    () {
                                                                  openImagePickerCameragst();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }),

                                      ],
                                    ),
                                  ) :
                                  GestureDetector(
                                    onTap: () {
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
                                                      Expanded(child: Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        onPressed:
                                                            () async {
                                                          openImagePickergallerygst();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        ButtonName:
                                                        'Gallery',
                                                        ButtonRadius: 5,
                                                      ),),

                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(child: Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        ButtonName:
                                                        'Camera',
                                                        ButtonRadius: 5,
                                                        onPressed:
                                                            () {
                                                          openImagePickerCameragst();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Image.network(Gst_networkimage,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'FSSAI number*',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: bluefont,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('The Food Safety and Standards Act, 2006 mandates every food business operator to obtain an FSSAI license or registration before commencing any food business.'),showChildAboveOverlay: false
                                      ,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 35,
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: kitchenFSSAIcontroller,
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      //      hintText: 'Insert Vat',
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
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
                                const SizedBox(height: 10),
                                Text(
                                  'FSSAI Photo*',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: grey300, width: 0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: fssaiphoto != null
                                      ? GestureDetector(
                                      onTap: () {
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
                                                        Expanded(child:  Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          onPressed:
                                                              () async {
                                                            openImagePickergalleryfssai();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          ButtonName:
                                                          'Gallery',
                                                          ButtonRadius: 5,
                                                        ),),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(child: Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          ButtonName:
                                                          'Camera',
                                                          ButtonRadius: 5,
                                                          onPressed:
                                                              () {
                                                            openImagePickerCamerafssai();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Image.file(
                                          fssaiphoto!, fit: BoxFit.fitHeight))
                                      : FSSAI_networkimage.isEmpty ||
                                      FSSAI_networkimage == '' ?
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            child: Center(
                                              child: Image.network(
                                                'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg',

                                              ),
                                            ),
                                            onTap: () {
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
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                onPressed:
                                                                    () async {
                                                                  openImagePickergalleryfssai();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                ButtonName:
                                                                'Gallery',
                                                                ButtonRadius: 5,
                                                              ),),

                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                ButtonName:
                                                                'Camera',
                                                                ButtonRadius: 5,
                                                                onPressed:
                                                                    () {
                                                                  openImagePickerCamerafssai();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }),

                                      ],
                                    ),
                                  ) :
                                  GestureDetector(
                                    onTap: () {
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
                                                      Expanded(child: Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        onPressed:
                                                            () async {
                                                          openImagePickergalleryfssai();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        ButtonName:
                                                        'Gallery',
                                                        ButtonRadius: 5,
                                                      ), ),

                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(child: Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        ButtonName:
                                                        'Camera',
                                                        ButtonRadius: 5,
                                                        onPressed:
                                                            () {
                                                          openImagePickerCamerafssai();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Image.network(FSSAI_networkimage,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text('GST',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: bluefont,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.w500),),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('GST'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 35,
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    controller: gstoptionn,

                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "5%",
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
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
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 35,
                                //   child: CustomDropdown(
                                //     borderRadius: BorderRadius.circular(4),
                                //     borderSide: BorderSide(color: grey300),
                                //     hintText: cuisineselecteOption.isEmpty
                                //         ? '5 %'
                                //         : cuisineselecteOption,
                                //     selectedStyle: TextStyle(
                                //         fontSize: 13, color: grey),
                                //     hintStyle: TextStyle(
                                //         fontSize: 13, color: grey),
                                //     items: gstoption,
                                //
                                //     controller: gstoptionn,
                                //
                                //     onChanged: (value) {
                                //       // setState(() {
                                //       //
                                //       //   for (var food in cuisinesData) {
                                //       //     if (food['name'] == value) {
                                //       //       setState(() {
                                //       //         cuisines.text = food['name'];
                                //       //
                                //       //         cuisineselecteOption = value;
                                //       //         selecteOptionID = food['id'];
                                //       //         print('--------cuisine------> $cuisineselecteOption');
                                //       //         print('--------cuisine------> $selecteOptionID');
                                //       //
                                //       //       });
                                //       //       break; // Exit the loop once you find the matching food
                                //       //     }
                                //       //   }
                                //       // });
                                //     },
                                //   ),
                                // ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Cuisines*',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: bluefont,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('''Cuisine is a type of food that is cooked in a specific way based on a culture's ingredients, region, and traditions.'''),showChildAboveOverlay: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    showDialog(
                                      context: context, builder: (context) =>
                                        certificateDialog(
                                          titel: 'Cuisines',
                                          selectCts: cuisine,
                                          onSelectedCertiChanged: (value) {
                                            setState(() {
                                              print(
                                                  '--------CuisinesID------> $value');
                                              CuisinesID = value;
                                            });
                                          },
                                          onSelectedCtsChanged: (value) {
                                            setState(() {
                                              print(
                                                  '--------selectedCertificateValue------> $value');
                                              selectedCertificateValue = value;
                                            });
                                          },
                                          selectCertificate: CuisinesID,
                                          selectedCts: selectedCertificateValue,

                                        ),);
                                    // showRadioButtonDialog();

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
                                          Container(width: 73.w,
                                            child: Text(
                                                selectedCertificateValue.isEmpty
                                                    ? ''
                                                    : selectedCertificateValue
                                                    .toString()
                                                    .replaceAll('[', '')
                                                    .replaceAll(']', ''),
                                                style: TextStyle(
                                                    fontSize: 13, color: grey,overflow: TextOverflow.ellipsis,)),
                                          ),
                                          const Spacer(),
                                          Icon(Icons.keyboard_arrow_down,
                                              size: 20, color: grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Mobile*',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                //const SizedBox(height: 10),
                                Container(
                                  height: 60,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  child:
                                  // kitchen.isEmpty? IntlPhoneField(
                                  //   invalidNumberMessage: "Invalid Mobile Number",
                                  //   style: TextStyle(
                                  //       color: black,
                                  //       fontSize:
                                  //       16,
                                  //       height: 1.8
                                  //   ),
                                  //   dropdownTextStyle:TextStyle(
                                  //       color: black,
                                  //       fontSize:
                                  //       16
                                  //   ),
                                  //   initialCountryCode: mobileNumber.isEmpty ?"IN":  selected_coutry.isEmpty ? '':selected_coutry,
                                  //   focusNode: focusNode2,
                                  //   //controller: userphonecontroller,
                                  //   initialValue: mobileNumber,
                                  //   decoration: InputDecoration(
                                  //     isDense: true,
                                  //     contentPadding: const EdgeInsets.only(left: 10),
                                  //   //  hintText: 'Mobile',
                                  //     hintStyle: TextStyle(
                                  //       color: Colors.grey.shade300,
                                  //       fontSize:
                                  //       MediaQuery.of(context).size.width *
                                  //           0.03,),
                                  //     border: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //     ),
                                  //     focusedBorder: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       borderSide: BorderSide(
                                  //         color: grey300,
                                  //         width: 1,
                                  //       ),
                                  //     ),
                                  //     enabledBorder: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       borderSide: BorderSide(
                                  //         color: grey300,
                                  //         width: 1,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   onChanged: (phone) {
                                  //     setState(() {
                                  //       mobileNumber = phone.completeNumber;
                                  //     });
                                  //     // You can add any additional logic you need when the phone number changes
                                  //   },
                                  //   onCountryChanged: (country) {
                                  //     // You can add any additional logic you need when the selected country changes
                                  //   },
                                  // ):
                                  TextFormField(
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: kitchenMobilecontroller,

                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,hintText: "Mobile",
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
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
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                mapshow==false? InkWell(
                                  onTap: () async {
                                    setState(() {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      select_curr_location=true;
                                    });

                                    PermissionStatus status = await Permission.location.request();

                                    if (status == PermissionStatus.granted) {
                                      setState(() {
                                        mapshow = true;
                                        select_curr_location=false;
                                      });
                                    } else {

                                    }

                                    // LocationPermission permission = await Geolocator.checkPermission();
                                    // if(permission.name.toString() == 'denied'){
                                    //   await Geolocator.requestPermission();
                                    // }
                                    // print('------permission profile----> ${permission.name}');
                                    //
                                    // if(permission.name == "whileInUse"){
                                    //
                                    //   Position position = await Geolocator.getCurrentPosition(
                                    //       desiredAccuracy: LocationAccuracy.high);
                                    //
                                    //   setState(() {
                                    //     current_lat = position.latitude;
                                    //     current_long = position.longitude;
                                    //     select_curr_location=false;
                                    //     mapshow = true;
                                    //   });
                                    // }
                                    // setState(() {
                                    //   select_curr_location=false;
                                    // });

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Container(
                                      height: 40,

                                      decoration: BoxDecoration(
                                          color: orange,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                          child: select_curr_location == true ? SizedBox(height: 25,width:25,child: CircularProgressIndicator(color: white)) : const Text('Get current Location ',
                                            style: TextStyle(
                                                color: Colors.white),)),
                                    ),
                                  ),
                                ):Container(),
                                mapshow?  SizedBox(
                              height:400,
                              child:  FlutterLocationPicker(
                                  initPosition: LatLong(current_lat, current_long),
                                  searchBarBackgroundColor: Colors.white,
                                  selectLocationButtonStyle: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                  ),
                                  selectedLocationButtonTextstyle: const TextStyle(fontSize: 14),
                                  loadingWidget: Center(
                                child: CircularProgressIndicator(color: blue),
                              ),
                                  initZoom: 15,locationButtonsColor: Colors.black,locationButtonBackgroundColor: Colors.white,
                                  showSearchBar: true,zoomButtonsBackgroundColor: Colors.white,zoomButtonsColor: Colors.black ,
                                  minZoomLevel: 5,
                                  maxZoomLevel: 16,
                                  trackMyPosition: false,
                                  showZoomController: true,
                                  showSelectLocationButton: false,
                                  onError: (e) => print(e),
                                  onPicked: (pickedData) async {
                                    // List<Placemark> placemarks = await placemarkFromCoordinates(pickedData.latLong.latitude, pickedData.latLong.longitude);
                                    // final add = placemarks.first;
                                    // address = add.locality.toString() + ", " + add.administrativeArea.toString() + ", " + add.country.toString();
                                    // setState(() {
                                    //   kitchenAddresscontroller.text = address;
                                    //   kitchenPinCodecontroller.text = add.postalCode.toString();
                                    // });
                                    // print(pickedData.latLong.latitude);
                                    // print(pickedData.latLong.longitude);
                                    // print(pickedData.address);
                                    // print(pickedData.addressData['country']);
                                    print('-----pickeddd-----${pickedData.address}');
                                    print('-----pickeddd-----${pickedData.addressData}');
                                    print('-----pickeddd-----${pickedData.latLong.latitude}');
                                    print('-----pickeddd-----${pickedData.latLong.longitude}');
                                  },
                                  onChanged: (pickedData) async {
                                    List<Placemark> placemarks = await placemarkFromCoordinates(pickedData.latLong.latitude, pickedData.latLong.longitude);
                                    final add = placemarks.first;
                                   // address = add.locality.toString() + ", " + add.administrativeArea.toString() + ", " + add.country.toString();
                                    setState(() {
                                      kitchenAddresscontroller.text = pickedData.address;
                                      kitchenPinCodecontroller.text = add.postalCode.toString(); //  Remove line
                                      kitchenPinCodecontroller.text = pickedData.addressData['postcode'].toString();  // Add line
                                      kitchenLatitudecontroller.text = pickedData.latLong.latitude.toString();
                                      kitchenLongitudecontroller.text = pickedData.latLong.longitude.toString();
                                      cityName = pickedData.addressData['state_district'].toString().replaceAll('District', '').replaceAll(' ', '');
                                    });
                                    print('-----picked-----${pickedData.addressData}');
                                    print('-----picked-----${cityName}');
                                    print('-----picked-----${kitchenPinCodecontroller.text}');
                                    print('-----picked-----${kitchenLatitudecontroller.text}');
                                    print('-----picked-----${kitchenLongitudecontroller.text}');
                                  }),
                            ):const SizedBox(),

                            // Container(height: 400,
                            //   child: PlacePicker(
                            //     resizeToAvoidBottomInset:
                            //     false, // only works in page mode, less flickery
                            //     apiKey: "AIzaSyAAxsVoD4kcp8muRJcLUxiQkT8zXkolIaQ",
                            //     hintText: "Find a place ...",
                            //     searchingText: "Please wait ...",initialMapType: MapType.satellite,
                            //     selectText: "Select place",
                            //     outsideOfPickAreaText: "Place not in area",
                            //     initialPosition:  LatLng(-33.8567844, 151.213108),
                            //     useCurrentLocation: true,
                            //     selectInitialPosition: true,
                            //     usePinPointingSearch: true,
                            //     usePlaceDetailSearch: true,
                            //     zoomGesturesEnabled: true,
                            //     zoomControlsEnabled: true,
                            //     ignoreLocationPermissionErrors: true,
                            //     onMapCreated: (GoogleMapController controller) {
                            //       print("Map created");
                            //     },
                            //     onPlacePicked: (PickResult result) {
                            //       print(
                            //           "Place picked: ${result.formattedAddress}");
                            //       setState(() {
                            //         selectedPlace = result;
                            //         Navigator.of(context).pop();
                            //       });
                            //       print("current location...... ${selectedPlace.toString()}");
                            //     },
                            //     onMapTypeChanged: (MapType mapType) {
                            //       print("Map type changed to ${mapType.toString()}");
                            //     },
                            //
                            //   ),
                            // ),

                                // Center(
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: <Widget>[
                                //       // Row(
                                //       //   mainAxisAlignment: MainAxisAlignment.center,
                                //       //   children: [
                                //       //     if (!_mapsInitialized &&
                                //       //         widget.mapsImplementation
                                //       //         is GoogleMapsFlutterAndroid) ...[
                                //       //       Switch(
                                //       //           value: (widget.mapsImplementation
                                //       //           as GoogleMapsFlutterAndroid)
                                //       //               .useAndroidViewSurface,
                                //       //           onChanged: (value) {
                                //       //             setState(() {
                                //       //               (widget.mapsImplementation
                                //       //               as GoogleMapsFlutterAndroid)
                                //       //                   .useAndroidViewSurface = value;
                                //       //             });
                                //       //           }),
                                //       //       Text("Hybrid Composition"),
                                //       //     ]
                                //       //   ],
                                //       // ),
                                //       // Row(
                                //       //   mainAxisAlignment: MainAxisAlignment.center,
                                //       //   children: [
                                //       //       Text("Renderer: "),
                                //       //       Radio(
                                //       //           groupValue: _mapsRenderer,
                                //       //           value: "auto",
                                //       //           onChanged: (value) {
                                //       //             setState(() {
                                //       //               _mapsRenderer = "auto";
                                //       //             });
                                //       //           }),
                                //       //       Text("Auto"),
                                //       //       Radio(
                                //       //           groupValue: _mapsRenderer,
                                //       //           value: "legacy",
                                //       //           onChanged: (value) {
                                //       //             setState(() {
                                //       //               _mapsRenderer = "legacy";
                                //       //             });
                                //       //           }),
                                //       //       Text("Legacy"),
                                //       //       Radio(
                                //       //           groupValue: _mapsRenderer,
                                //       //           value: "latest",
                                //       //           onChanged: (value) {
                                //       //             setState(() {
                                //       //               _mapsRenderer = "latest";
                                //       //             });
                                //       //           }),
                                //       //       Text("Latest"),
                                //       //
                                //       //   ],
                                //       // ),
                                //
                                //       !_showPlacePickerInContainer
                                //           ? ElevatedButton(
                                //         child: Text("Load Place Picker in Container"),
                                //         onPressed: () {
                                //
                                //           setState(() {
                                //             _showPlacePickerInContainer = true;
                                //           });
                                //         },
                                //       )
                                //           : Container(
                                //           width: MediaQuery.of(context).size.width * 0.75,
                                //           height: MediaQuery.of(context).size.height * 0.35,
                                //           child: PlacePicker(
                                //               apiKey:"AIzaSyBQt-bwom5Z3fnNee4eLwca7RZWtkzi_SM",
                                //               hintText: "Find a place ...",
                                //               searchingText: "Please wait ...",
                                //               selectText: "Select place",
                                //               initialPosition:  LatLng(-33.8567844, 151.213108),
                                //               useCurrentLocation: true,
                                //               selectInitialPosition: true,
                                //               usePinPointingSearch: true,
                                //               usePlaceDetailSearch: true,
                                //               zoomGesturesEnabled: true,
                                //               zoomControlsEnabled: true,
                                //               ignoreLocationPermissionErrors: true,
                                //               onPlacePicked: (PickResult result) {
                                //                 setState(() {
                                //                   selectedPlace = result;
                                //                   print('error :-> '+ selectedPlace!.geometry!.location.lat.toString());
                                //                   _showPlacePickerInContainer = true;
                                //                 });
                                //               },
                                //               onTapBack: () {
                                //                 setState(() {
                                //                   _showPlacePickerInContainer = false;
                                //                 });
                                //               })),
                                //       if (selectedPlace != null) ...[
                                //         Text(selectedPlace!.formattedAddress!),
                                //
                                //         Text("(lat: " +
                                //             selectedPlace!.geometry!.location.lat.toString() +
                                //             ", lng: " +
                                //             selectedPlace!.geometry!.location.lng.toString() +
                                //             ")"),
                                //       ],
                                //       // #region Google Map Example without provider
                                //       // _showPlacePickerInContainer
                                //       //     ? Container()
                                //       //     : ElevatedButton(
                                //       //   child: Text("Toggle Google Map w/o Provider"),
                                //       //   onPressed: () {
                                //       //     setState(() {
                                //       //       _showGoogleMapInContainer =
                                //       //       !_showGoogleMapInContainer;
                                //       //     });
                                //       //   },
                                //       // ),
                                //       // !_showGoogleMapInContainer
                                //       //     ? Container()
                                //       //     : Container(
                                //       //     width: MediaQuery.of(context).size.width * 0.75,
                                //       //     height: MediaQuery.of(context).size.height * 0.25,
                                //       //     child: GoogleMap(
                                //       //       zoomGesturesEnabled: false,
                                //       //       zoomControlsEnabled: false,
                                //       //       myLocationButtonEnabled: false,
                                //       //       mapToolbarEnabled: false,
                                //       //       initialCameraPosition: new CameraPosition(
                                //       //           target: LatLng(-33.8567844, 151.213108), zoom: 15),
                                //       //       mapType: MapType.normal,
                                //       //       myLocationEnabled: true,
                                //       //       onMapCreated: (GoogleMapController controller) {},
                                //       //       onCameraIdle: () {},
                                //       //       onCameraMoveStarted: () {},
                                //       //       onCameraMove: (CameraPosition position) {},
                                //       //     )),
                                //       // !_showGoogleMapInContainer ? Container() : TextField(),
                                //       // #endregion
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 300,
                                //   child:
                                //   GoogleMap(
                                //     initialCameraPosition: _kGooglePlex,
                                //     mapType: MapType.terrain,
                                //     myLocationButtonEnabled: true,
                                //     myLocationEnabled: true,
                                //     markers: Set<Marker>.of(_markers),
                                //     onTap: (LatLng latLng) async {
                                //       List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
                                //       final add = placemarks.first;
                                //       address = add.locality.toString() + ", " + add.administrativeArea.toString() + ", " + add.country.toString();
                                //       print('---address-----> $add');
                                //
                                //       Marker newMarker = Marker(
                                //         markerId: MarkerId("SomeId"),
                                //         draggable: true,
                                //         position: LatLng(latLng.latitude, latLng.longitude),
                                //         onDragEnd: (newPosition) async {
                                //           // List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);
                                //           // final add = placemarks.first;
                                //           // address = add.locality.toString() + ", " + add.administrativeArea.toString() + ", " + add.country.toString();
                                //           // setState(() {
                                //           //   kitchenAddresscontroller.text = address;
                                //           //   kitchenPinCodecontroller.text = add.postalCode.toString();
                                //           // });
                                //         },
                                //         infoWindow: InfoWindow(title: address),
                                //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                                //       );
                                //       _markers.add(newMarker);
                                //       setState(() {
                                //         kitchenAddresscontroller.text = address;
                                //         kitchenPinCodecontroller.text = add.postalCode.toString();
                                //       });
                                //       print("Our lat and long is : $latLng");
                                //       //_goToTheLake();
                                //     },
                                //     onMapCreated: (
                                //         GoogleMapController controller) {
                                //       _controller.complete(controller);
                                //     },
                                //   ),
                                // ),
                                // const SizedBox(height: 10),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  'Address*',
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
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    controller: kitchenAddresscontroller,
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                  //    hintText: 'Insert Address',
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
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
                                const SizedBox(height: 10),
                                Text(
                                  'Pin Code*',
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
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 13,
                                      fontFamily: fontfamily,
                                    ),
                                    controller: kitchenPinCodecontroller,
                                    cursorColor: grey,
                                    decoration: InputDecoration(
                                      isDense: true,
                                     // hintText: 'Insert Pin code',
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 13,
                                        fontFamily: fontfamily,
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
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
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No of Seats for Dine-In',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: bluefont,
                                        fontFamily: fontfamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Breakfast*',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: fontfamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                height: 35,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: grey,
                                                    fontSize: 13,
                                                    fontFamily: fontfamily,
                                                  ),
                                                  controller: breakfastDineInController,
                                                  cursorColor: grey,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    hintStyle: TextStyle(
                                                      color: grey,
                                                      fontSize: 13,
                                                      fontFamily: fontfamily,
                                                    ),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Lunch*',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: fontfamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                height: 35,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: grey,
                                                    fontSize: 13,
                                                    fontFamily: fontfamily,
                                                  ),
                                                  controller: lunchDineInController,
                                                  cursorColor: grey,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    hintStyle: TextStyle(
                                                      color: grey,
                                                      fontSize: 13,
                                                      fontFamily: fontfamily,
                                                    ),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Snacks*',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: fontfamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                height: 35,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: grey,
                                                    fontSize: 13,
                                                    fontFamily: fontfamily,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  controller: snacksDineInController,

                                                  cursorColor: grey,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    hintStyle: TextStyle(
                                                      color: grey,
                                                      fontSize: 13,
                                                      fontFamily: fontfamily,
                                                    ),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dinner*',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: bluefont,
                                                  fontFamily: fontfamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                height: 35,
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: grey,
                                                    fontSize: 13,
                                                    fontFamily: fontfamily,
                                                  ),
                                                  controller: dinnerDineInController,
                                                  cursorColor: grey,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    hintStyle: TextStyle(
                                                      color: grey,
                                                      fontSize: 13,
                                                      fontFamily: fontfamily,
                                                    ),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Number of Delivery per Day*',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: bluefont,
                                        fontFamily: fontfamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                     SizedBox(width: 5.w,),
                                    Expanded(
                                      child: Container(
                                        height: 35,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: grey,
                                            fontSize: 13,
                                            fontFamily: fontfamily,
                                          ),
                                          controller: nuofdelivaryController,
                                          cursorColor: grey,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintStyle: TextStyle(
                                              color: grey,
                                              fontSize: 13,
                                              fontFamily: fontfamily,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
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
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Kitchen Photo*',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: grey300, width: 0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: image != null
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
                                                        Expanded(child: Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          onPressed:
                                                              () async {
                                                            openImagePicker();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          ButtonName:
                                                          'Gallery',
                                                          ButtonRadius: 5,
                                                        ), ),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(child:   Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          ButtonName:
                                                          'Camera',
                                                          ButtonRadius: 5,
                                                          onPressed:
                                                              () {
                                                            openImagePickerCameraKitchen();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Image.file(
                                          image!, fit: BoxFit.fitHeight))
                                      : Kitchen_networkimage.isEmpty ||
                                      Kitchen_networkimage == '' ?
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            child: Center(
                                              child: Image.network(
                                                'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg',

                                              ),
                                            ),
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
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                onPressed:
                                                                    () async {
                                                                  openImagePicker();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                ButtonName:
                                                                'Gallery',
                                                                ButtonRadius: 5,
                                                              ),),

                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                ButtonName:
                                                                'Camera',
                                                                ButtonRadius: 5,
                                                                onPressed:
                                                                    () {
                                                                  openImagePickerCameraKitchen();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }),

                                      ],
                                    ),
                                  ) :
                                  GestureDetector(
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
                                                      Expanded(child:  Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        onPressed:
                                                            () async {
                                                          openImagePicker();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        ButtonName:
                                                        'Gallery',
                                                        ButtonRadius: 5,
                                                      ),),

                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(child:  Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        ButtonName:
                                                        'Camera',
                                                        ButtonRadius: 5,
                                                        onPressed:
                                                            () {
                                                          openImagePickerCameraKitchen();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Image.network(Kitchen_networkimage,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Infrastructure  Photo*',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: grey300, width: 0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: imageinfra != null
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
                                                        Expanded(child:  Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          onPressed:
                                                              () async {
                                                            openImagePickerinfra();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          ButtonName:
                                                          'Gallery',
                                                          ButtonRadius: 5,
                                                        ),),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(child:  Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          ButtonName:
                                                          'Camera',
                                                          ButtonRadius: 5,
                                                          onPressed:
                                                              () {
                                                            openImagePickerCamerainfra();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Image.file(
                                          imageinfra!, fit: BoxFit.fitHeight))
                                      : infra_networkimage.isEmpty ||
                                      infra_networkimage == '' ?
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            child: Center(
                                              child: Image.network(
                                                'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg',

                                              ),
                                            ),
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
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                onPressed:
                                                                    () async {
                                                                  openImagePickerinfra();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                ButtonName:
                                                                'Gallery',

                                                              ),),

                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(child:  Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                ButtonName:
                                                                'Camera',
                                                                ButtonRadius: 5,
                                                                onPressed:
                                                                    () {
                                                                  openImagePickerCamerainfra();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }),

                                      ],
                                    ),
                                  ) :
                                  GestureDetector(
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
                                                      Expanded(child:Wid_Con
                                                      .button(
                                                  titelcolor:
                                                    white,
                                                    onPressed:
                                                        () async {
                                                      openImagePickerinfra();
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                    ButtonName:
                                                    'Gallery',
                                                    ButtonRadius: 5,
                                                  ), ),

                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(child: Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        ButtonName:
                                                        'Camera',
                                                        ButtonRadius: 5,
                                                        onPressed:
                                                            () {
                                                          openImagePickerCamerainfra();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ), ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Image.network(infra_networkimage,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Main Building Photo*',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: bluefont,
                                      fontFamily: fontfamily,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 110,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: grey300, width: 0.7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: imagebuilding != null
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
                                                        Expanded(child:   Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          onPressed:
                                                              () async {
                                                            openImagePickerbuilding();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          ButtonName:
                                                          'Gallery',
                                                          ButtonRadius: 5,
                                                        ),),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(child:  Wid_Con
                                                            .button(
                                                          titelcolor:
                                                          white,
                                                          ButtonName:
                                                          'Camera',
                                                          ButtonRadius: 5,
                                                          onPressed:
                                                              () {
                                                            openImagePickerCamerabuilding();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Image.file(
                                          imagebuilding!, fit: BoxFit.fitHeight))
                                      : building_networkimage.isEmpty ||
                                      building_networkimage == '' ?
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            child: Center(
                                              child: Image.network(
                                                'https://eatathome.in/app/public/storage/app/public/12/conversions/avatar-icon.jpg',

                                              ),
                                            ),
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
                                                              Expanded(child: Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                onPressed:
                                                                    () async {
                                                                  openImagePickerbuilding();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                ButtonName:
                                                                'Gallery',
                                                                ButtonRadius: 5,
                                                              ),),

                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(child:  Wid_Con
                                                                  .button(
                                                                titelcolor:
                                                                white,
                                                                ButtonName:
                                                                'Camera',
                                                                ButtonRadius: 5,
                                                                onPressed:
                                                                    () {
                                                                  openImagePickerCamerabuilding();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }),

                                      ],
                                    ),
                                  ) :
                                  GestureDetector(
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
                                                      Expanded(child:  Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        onPressed:
                                                            () async {
                                                          openImagePickerbuilding();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        ButtonName:
                                                        'Gallery',
                                                        ButtonRadius: 5,
                                                      ),),

                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(child: Wid_Con
                                                          .button(
                                                        titelcolor:
                                                        white,
                                                        ButtonName:
                                                        'Camera',
                                                        ButtonRadius: 5,
                                                        onPressed:
                                                            () {
                                                          openImagePickerCamerabuilding();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),)

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Image.network(building_networkimage,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Description*',
                                      style: TextStyle(
                                          fontFamily: fontfamily,
                                          fontSize: 12,
                                          color: bluefont,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('Description about your kitchen'),showChildAboveOverlay: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  maxLines: 5,
                                  style: TextStyle(color: grey),
                                  controller: DescriptionController,
                                  decoration: InputDecoration(
                                    // isDense: true,
                                    //  hintText: 'Description',
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
                                const SizedBox(height: 10),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Upload Document*',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: bluefont,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    const ElTooltip(
                                      child: Icon(Icons.info_outline, size: 17,),
                                      content: Text('Upload Document related to your kitchen'),showChildAboveOverlay: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                            Wid_Con.button(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                FilePickerResult? result = await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  int maxSizeInBytes = 10 * 1024 * 1024; // 2 MB
                                  if (result.files.first.size <= maxSizeInBytes) {
                                    setState(() {
                                      PickDocuments = File(result.files.single.path!);
                                      documntName = result.files.first.name;
                                      print('---------------file------------> $PickDocuments');
                                      print('---------------file------------> ${documntName}');
                                      print('---------------file------------> ${result.files.first.bytes}');
                                      print('---------------file------------> ${result.files.first.size}');
                                    });
                                  } else {
                                    // File size exceeds the limit
                                  setState(() {
                                    document_size = true;
                                    documntName = "Document size exceeds the limit (10 MB)";
                                  });
                                  }
                                } else {}
                              },
                              Bordercolor: grey,
                              ButtonColor: white,
                              titelcolor: black,
                              ButtonName: 'Document',
                              height: 40,
                              ButtonRadius: 5,
                              fontSize: 14,
                              BorderWidth: 1.5,
                            ),
                            const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$documntName',
                                  style: TextStyle(
                                    color: document_size == true ? red: grey,
                                    fontSize: 12,
                                    fontFamily: fontfamily,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment details (Optional)',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: bluefont,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextButton( onPressed: () {
                                      setState(() {
                                        isedited_bankdetails = !isedited_bankdetails;
                                      });
                                    }, child:Text("Edit" , style: TextStyle(
                                        fontSize: 12,
                                        color: bluefont,
                                        fontFamily: fontfamily,
                                        fontWeight: FontWeight.w500),),)
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Bank Account Number',
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
                                    style: TextStyle(color: Colors.grey),
                                    controller: cardNumberController,
                                    cursorColor: grey,

                                    readOnly: isedited_bankdetails,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(

                                      filled: isedited_bankdetails,
                                      fillColor: Colors.grey.shade200,
                                      isDense: true,
                                      contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
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
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bank Name',
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
                                        controller: expiryDateController,
                                        cursorColor: grey,
                                        readOnly: isedited_bankdetails,
                                        decoration: InputDecoration(
                                          filled: isedited_bankdetails,
                                          fillColor: Colors.grey.shade200,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
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
                                const SizedBox(width: 20),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'IFSC Code',
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
                                        controller: cvvController,
                                        cursorColor: grey,
                                        readOnly: isedited_bankdetails,
                                        decoration: InputDecoration(
                                          filled: isedited_bankdetails,
                                          fillColor: Colors.grey.shade200,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
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
                                const SizedBox(height: 10),
                                Text(
                                  'Account Holder Name',
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
                                    controller: cardHolderNameController,
                                    cursorColor: grey,
                                    readOnly: isedited_bankdetails,
                                    decoration: InputDecoration(
                                      filled: isedited_bankdetails,
                                      fillColor: Colors.grey.shade200,
                                      isDense: true,
                                      contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: Wid_Con.button(
                                ButtonName: 'Submit',
                                onPressed: () {
                                  print('---------lat--long----> ${cityName}--${kitchenAddresscontroller.text}--${kitchenPinCodecontroller.text}');
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  final emailValidator = RegExp(r'\S+@\S+\.\S+');

                                  if(avatar_image==null && User_networkimage==""){
                                    Wid_Con.toastmsgr(context: context,msg:"User photo Required !");
                                  }
                                else if(usernamecontroller.text.isEmpty){
                                    // Fluttertoast.showToast(
                                    //   msg: "Username Required !",
                                    //   fontSize: 16,
                                    //   backgroundColor: black,
                                    //   gravity: ToastGravity.BOTTOM,
                                    //   textColor: white,
                                    // );
                                    Wid_Con.toastmsgr(context: context,msg:"User Name Required !");
                                  }
                                  else if(useremailcontroller.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"User Email Required !");
                                  }
                                  else if(!emailValidator.hasMatch(useremailcontroller.text)){
                                    Wid_Con.toastmsgr(context: context,msg:"The email format is invalid");
                                  }
                                  else if(BiographyController.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Short biography Required !");
                                  }

                                  else if(useraddresscontroller.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"User Address Required !");
                                  }
                                  else if(kitchennamecontroller.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Kitchen Name Required !");
                                  }
                                  else if(kitchenFSSAIcontroller.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"FSSAI number Required !");
                                  }
                                  else if(fssaiphoto==null && FSSAI_networkimage==""){
                                    Wid_Con.toastmsgr(context: context,msg:"FSSAI photo Required !");
                                  }
                                  else if(selectedCertificateValue.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Cuisines Required !");
                                  }

                                  else if (kitchen.isEmpty && kitchenMobilecontroller.text.length<6) {
                                    Wid_Con.toastmsgr(context: context,msg:"Invalid Mobile Number!");
                                    // print("=========>>>>>"+mobileNumber);
                                    print("=========>>>>>"+kitchenMobilecontroller.text);
                                  }
                                  else if (kitchen.isNotEmpty && kitchenMobilecontroller.text.isEmpty) {
                                    Wid_Con.toastmsgr(context: context,msg:"Mobile Number Required !");
                                  }
                                  else if(kitchenAddresscontroller.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Kitchen address Required !");
                                  }
                                  else if(kitchenPinCodecontroller.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Pincode Required !");
                                  }
                                  // else if(kitchenLongitudecontroller.text.isEmpty || kitchenLongitudecontroller.text.isEmpty){
                                  //   Wid_Con.toastmsgr(context: context,msg:"Current Location Required !");
                                  // }
                                  else if(breakfastDineInController.text.isEmpty || lunchDineInController.text.isEmpty || snacksDineInController.text.isEmpty || dinnerDineInController.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"No. of Seats for Dine-in Required !");
                                  }
                                  else if(nuofdelivaryController.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Number of Delivery Required !");
                                  }
                                  else if(image==null && Kitchen_networkimage==""){
                                    Wid_Con.toastmsgr(context: context,msg:"Kitchen photo Required !");
                                  }
                                  else if(imageinfra==null && infra_networkimage==""){
                                    Wid_Con.toastmsgr(context: context,msg:"Infrastructure photo Required !");
                                  }
                                  else if(imagebuilding==null && building_networkimage==""){
                                    Wid_Con.toastmsgr(context: context,msg:"Building photo Required !");
                                  }
                                  else if(DescriptionController.text.isEmpty){
                                    Wid_Con.toastmsgr(context: context,msg:"Kitchen Description Required !");
                                  }
                                  else if(documntName==""){
                                    Wid_Con.toastmsgr(context: context,msg:"Documents Required !");
                                  }

                            else{
                                   print("=========>>>>>"+kitchenMobilecontroller.text);
                                    kitchen_Details(
                                      isOpen: kitchenstatus.value==false?'1':'0',
                                        name: kitchennamecontroller.text.isEmpty
                                            ? ''
                                            : kitchennamecontroller.text,
                                        gst_number:kitchenVatcontroller.text,
                                        fssai_number:kitchenFSSAIcontroller.text.isEmpty?'':kitchenFSSAIcontroller.text,
                                        number_of_delivery:nuofdelivaryController.text,
                                        phone: phoneNumber.isEmpty
                                            ? ''
                                            : phoneNumber,
                                        mobile: kitchenMobilecontroller.text.isEmpty
                                            ? ''
                                            : kitchenMobilecontroller.text,
                                        address:
                                        kitchenAddresscontroller.text.isEmpty
                                            ? ''
                                            : kitchenAddresscontroller.text,
                                        latitude:
                                        kitchenLatitudecontroller.text.isEmpty
                                            ? ''
                                            : kitchenLatitudecontroller.text,
                                        longitude:
                                        kitchenLongitudecontroller.text.isEmpty
                                            ? ''
                                            : kitchenLongitudecontroller.text,
                                        slots: kitchenSlotscontroller.text.isEmpty
                                            ? ''
                                            : kitchenSlotscontroller.text,
                                        description: DescriptionController.text,
                                        information: InformationController.text,
                                        userName: usernamecontroller.text.isEmpty
                                            ? ''
                                            : usernamecontroller.text,
                                        userEmail: useremailcontroller.text.isEmpty
                                            ? ''
                                            : useremailcontroller.text,
                                        useraddress:
                                        useraddresscontroller.text.isEmpty
                                            ? ''
                                            : useraddresscontroller.text,
                                        userphone: phoneNumber.isEmpty
                                            ? ''
                                            : phoneNumber,
                                        userpassword:
                                        userpasscontroller.text.isEmpty
                                            ? ''
                                            : userpasscontroller.text,
                                        userbio: BiographyController.text ,
                                        useravatar: avatar_image,
                                        kitchenimage: image,
                                        gst_photo: gstphoto,
                                        fssai_photo: fssaiphoto,
                                        infrastructure_image: imageinfra,
                                        main_building_image: imagebuilding,
                                        availableFordelivery: isCheck == true ? 1
                                            .toString() : 0.toString(),
                                        // closed: isChecked == true ? 1.toString() : 0
                                        //     .toString(),
                                        cuisinesid: CuisinesID.isEmpty
                                            ? []
                                            : CuisinesID,
                                        Documents: PickDocuments,
                                        expiry_date: expiryDateController.text.isEmpty
                                            ? ''
                                            : expiryDateController.text,
                                        card_number: cardNumberController.text.isEmpty
                                            ? ''
                                            : cardNumberController.text,
                                        holder_name: cardHolderNameController.text.isEmpty
                                            ? ''
                                            : cardHolderNameController.text,
                                        cvv: cvvController.text.isEmpty
                                            ? ''
                                            : cvvController.text,
                                        pincode: kitchenPinCodecontroller.text.isEmpty?'':kitchenPinCodecontroller.text,
                                        vat: kitchenVatcontroller.text.isEmpty?'':kitchenVatcontroller.text,
                                        breakfastslots: breakfastDineInController.text.isEmpty ?'':breakfastDineInController.text,
                                        lunchslots: lunchDineInController.text.isEmpty?'':lunchDineInController.text,
                                        dinnerslots: dinnerDineInController.text.isEmpty?'':dinnerDineInController.text,
                                        snacksslots: snacksDineInController.text.isEmpty?'':snacksDineInController.text,
                                        city: cityName
                                    );
                                  }


                                },
                                width: 80,
                                height: 35,
                                ButtonRadius: 5,
                                titelcolor: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    NoBlinkPageRoute<void>(
                                      builder: (BuildContext context) => const bottom_screen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: blue),
                                    ),
                                  ),
                                ),
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
              ),
            ),
                ),
          ),
        );
      }
    }

