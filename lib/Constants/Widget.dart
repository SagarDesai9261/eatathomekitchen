
import 'package:comeeathome/Pages/screens/bottombar_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../Pages/screens/Service/freshchat.dart';
import '../Pages/test.dart';
import 'App_Colors.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
class Wid_Con {
  final APPID = "ccd5820a-d45f-4698-8c06-81be62a9b153";
  final APPKEY = "32d74b1d-29ff-40ed-9355-2b97c0b20670";
  final DOMAIN = "msdk.in.freshchat.com";
  FreshchatUser? user;
  FreshchatService? service ;
  static iconButton(
      {required VoidCallback onPressed,
      required Icon BIcon,
      Color? Button_color,
      double? Iconsize,
      double? splashRadius}) {
    return IconButton(
      onPressed: onPressed,
      icon: BIcon,
      color: Button_color,
      iconSize: Iconsize,
      splashRadius: splashRadius,
    );
  }

  static textfield(
      {String? titelText,
      var suffixIcon,
      Color? fillColor,
      Color? cursorColor,
      var controller,
      double? paddingtop,
      double? paddingbottom,
      double? paddingleft,
      double? paddingright,
      var focusedBorder,
      var obscureText,
      errorBorder,
      key,
      errorText,
      String? labelText,
      var validator,
      var inputFormatters,
      String? hintText,
      var keyboardType,
      // ignore: use_function_type_syntax_for_parameters
      Function(String)? onChanged,
      var maxLines,
      double? width,
      double? height,
      Color? titelcolor,
      var borderSide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: paddingbottom ?? 0,
              left: paddingleft ?? 5,
              top: paddingtop ?? 0,
              right: paddingright ?? 0),
          child: Text(
            titelText ?? '',
            style: TextStyle(
                color: black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'),
          ),
        ),
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            validator: validator,
            style: TextStyle(fontWeight: FontWeight.w400, color: black),
            key: key,
            obscureText: obscureText ?? false,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            keyboardType: keyboardType ?? TextInputType.number,
            controller: controller,
            onChanged: onChanged,
            cursorColor: cursorColor ?? black,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: fillColor ?? white,
                focusColor: white,
                hoverColor: white,
                labelText: labelText,
                contentPadding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                suffixIcon: suffixIcon,
                hintText: hintText ?? '',
                hintStyle: TextStyle(
                    color: black,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Poppins'),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: white, width: 1)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: white, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 20,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: white, width: 1),
                ),
                errorText: errorText,
                floatingLabelStyle:
                    TextStyle(color: white, fontFamily: 'Poppins'),
                labelStyle: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
          ),
        ),
      ],
    );
  }

  static button(
      { String? ButtonName,
      var fontWeight,
      Color? titelcolor,
      Color? Bordercolor,
      required VoidCallback onPressed,
      double? ButtonRadius,
      double? BorderWidth,
      double? fontSize,
      double? bottomLeftRadius,
      double? bottomRightRadius,
      double? topLeftRadius,
      double? topRightRadius,
      Color? ButtonColor,
      double? width,
      double? height,
      var child,
      double? elevation}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius:ButtonRadius==null? BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeftRadius??0),
          bottomRight: Radius.circular(bottomRightRadius??0),
          topLeft: Radius.circular(topLeftRadius??0),
          topRight: Radius.circular(topRightRadius??0),
        ):BorderRadius.circular(ButtonRadius),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment(0.5, 3),
            colors: [
              Color(0xFFE49630),
              Color(0xFFC73C1B),
            ],
          )),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.amber, backgroundColor: ButtonColor ?? trans,
          elevation: 0,  // Elevation
          shadowColor: trans,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Bordercolor ?? trans,width: BorderWidth??0),
              borderRadius: ButtonRadius==null? BorderRadius.only(
                bottomLeft: Radius.circular(bottomLeftRadius??0),
                bottomRight: Radius.circular(bottomRightRadius??0),
                topLeft: Radius.circular(topLeftRadius??0),
                topRight: Radius.circular(topRightRadius??0),
              ):BorderRadius.circular(ButtonRadius),
          ),
        ),
        // style: ButtonStyle(
        //     elevation: MaterialStateProperty.all<double?>(elevation),
        //     minimumSize: MaterialStateProperty.all<Size?>(
        //         Size(width ?? double.infinity, height ?? 45)),
        //     backgroundColor:
        //         MaterialStateProperty.all(ButtonColor ?? trans),
        //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //         RoundedRectangleBorder(
        //       side: BorderSide(color: Bordercolor ?? trans),
        //       borderRadius: BorderRadius.circular(ButtonRadius ?? 8.0),
        //     ))),
        onPressed: onPressed,
        child: child ??
            Text(
              ButtonName.toString(),
              style: TextStyle(
                  color: titelcolor ?? black,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontFamily: 'Poppins'),
            ),
      ),
    );
  }

  static toastmsgr({String? msg, context}){
    return toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      foregroundColor: Colors.red,
      showProgressBar: false,
      context: context,
      title: Text(msg!),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  static toastmsgg({String? msg, context}){
    return toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      foregroundColor: Colors.green,
      showProgressBar: false,
      context: context,
      title: Text(msg!),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  static App_Bar(
      {String? titel,
      var leading,
      var Status,
      double? padding,
      var titelwidget,
        var fontweight,
      List<Widget>? actions,
      var arrowNearText}) {
    return AppBar(
        backgroundColor: trans,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Status ?? Container(),
            titelwidget ?? Container(),
            titel != null
                ? Padding(
                  padding:  EdgeInsets.only(left: padding ?? 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 61.w,
                          child: Text(titel ?? '',textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'Poppins',
                                  color: red,
                                  fontWeight: fontweight)),
                        ),
                        Icon(
                          arrowNearText,
                          size: 20,
                        ),
                      ],
                    ),
                )
                :   Container(width: 44.w,
              child: Image.asset('assets/images/logo2.png', fit: BoxFit.cover,),
            ),
          ],
        ),
        leading: leading,
        actions: actions);
  }
  void launchFreshchat() {
    Freshchat.init(APPID, APPKEY, DOMAIN);
/*    user!.setFirstName("Sagar");
    user!.setEmail("Sagar@gmail.com");
    user!.setPhone("+91", "9898989898");*/
    Freshchat.showConversations();
  }

  static drawer(
  {var width,VoidCallback? onPressedfav,VoidCallback? onPressedorder,VoidCallback? onPressedreview,VoidCallback? onPressedpay,VoidCallback? onPressedlan,VoidCallback? onPressedad,VoidCallback? onPressedlogout ,VoidCallback? onpressBannerimage ,VoidCallback? onPresprivacypolicy}


      ) {
    return Container(width: 60.w,
      child: Drawer(
        elevation: 0,
        backgroundColor: white,
        width: width,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.all(0.3),
                child: Image.asset('assets/images/come_eat.png',),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15),
            //   child: ListTile(
            //     visualDensity: const VisualDensity(vertical: -2),
            //     title: Row(
            //       children: [
            //         SizedBox(width: 30, child: Center(child: Image.asset('assets/images/favorite.png',height: 15))),
            //         const SizedBox(width: 10,),
            //         Text('Favorites',style: TextStyle(fontSize: 13, color: greyfont,fontFamily: fontfamily),textAlign: TextAlign.start),
            //       ],
            //     ),
            //     onTap: onPressedfav,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -2),
                title: Row(
                  children: [
                    SizedBox(width: 6.w,child: Center(child: Image.asset('assets/images/orders.png',height: 3.h,color: black,))),const SizedBox(width: 10,),
                    SizedBox(width: 1.w,),
                    Text('Orders',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                  ],
                ),
                onTap: onPressedorder
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -2),
                title: Row(
                  children: [
                    SizedBox(width: 6.w, child: Center(child: Image.asset('assets/images/review.png',height: 3.h,color: black),)),const SizedBox(width: 10,),
                    SizedBox(width: 1.w,),
                    Text('Review',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                  ],
                ),
                  onTap: onPressedreview
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -2),
                title: Row(
                  children: [
                    SizedBox(width: 6.w, child: Center(child: Image.asset('assets/images/payout.png',height: 15,color: black))),const SizedBox(width: 10,),
                    SizedBox(width: 1.w,),
                    Text('Payout',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                  ],
                ),
                  onTap: onPressedpay
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 5),
            //   child: ListTile(
            //     visualDensity: const VisualDensity(vertical: -2),
            //     title: Row(
            //       children: [
            //         SizedBox(width: 6.w, child: Center(child: Image.asset('assets/images/language.png',height: 3.h,color: black))),const SizedBox(width: 10,),
            //         SizedBox(width: 1.w,),
            //         Text('Language',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
            //       ],
            //     ),
            //       onTap: onPressedlan
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  title: Row(
                    children: [
                      SizedBox(width: 6.w, child: Center(child: Image.asset('assets/images/payout.png',height: 3.h,color: black))),const SizedBox(width: 10,),
                      SizedBox(width: 1.w,),
                      Text('Add Discount',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                    ],
                  ),
                  onTap: onPressedad
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  title: Row(
                    children: [
                      SizedBox(width: 6.w, child: Center(child: Image.asset('assets/images/orders.png',height: 3.h,color: black))),const SizedBox(width: 10,),
                      SizedBox(width: 1.w,),
                      Text('Banner Image',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                    ],
                  ),
                  onTap: onpressBannerimage
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  title: Row(
                    children: [
                      SizedBox(width: 6.w, child: Center(child: Icon(Icons.help_outline))),const SizedBox(width: 10,),
                      SizedBox(width: 1.w,),
                      Text('Help & Support',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                    ],
                  ),
                  onTap:()async{
                    FreshchatService service = FreshchatService();
                    service.showConversations();
    }

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  title: Row(
                    children: [
                      SizedBox(width: 6.w, child: Center(child: Icon(Icons.security))),const SizedBox(width: 10,),
                      SizedBox(width: 1.w,),
                      Text('Privacy Policy',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                    ],
                  ),
                  onTap: onPresprivacypolicy
              ),
            ),
            // const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -2),
                title: Row(
                  children: [
                    SizedBox(width: 6.w, child: Center(child: Image.asset('assets/images/logout.png',height: 3.h,color: black))),const SizedBox(width: 10,),
                    SizedBox(width: 1.w,),
                    Text('Logout',style: TextStyle(fontSize: 13.sp, color: black,fontFamily: fontfamily)),
                  ],
                ),
                  onTap: onPressedlogout
              ),
            ),
            // Add more items as needed
          ],
        ),
      ),
    );
  }



static idKitchenDialog(BuildContext context){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text('Kitchen details is not found'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please fill the kitchen details'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pushReplacement(context, NoBlinkPageRoute(builder: (context)=> const bottom_screen(pageindex: 4,)));
                    },
                  ),
                ),
              ],
            ),

          ],
        );
      },
    );
}

static showAlertDialog({required String message,required VoidCallback onPressed_no,required VoidCallback onPressed_yes}){
    return AlertDialog( // <-- SEE HERE
        title:  Text('$message'),
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12
        ),

        insetPadding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(child: Wid_Con.button(
                  ButtonName: 'No',
                  onPressed: onPressed_no,
                  height: 43,
                  ButtonRadius: 5,
                  ButtonColor: Colors.transparent,
                  titelcolor: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
              const SizedBox(width: 10),
              Expanded(
                  child: Wid_Con.button(
                      ButtonName: 'Yes',
                      onPressed:onPressed_yes,
                      ButtonRadius: 5,
                      height: 43,
                      ButtonColor: Colors.transparent,
                      titelcolor: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))
            ],
          ),

        ],
      );
}
}





