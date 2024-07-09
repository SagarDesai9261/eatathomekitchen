import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import '../../../Constants/App_Colors.dart';
import '../../../Constants/Widget.dart';

class ImageSelectionScreen extends StatefulWidget {
  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  List<bool> isSelected = [false, false, false, false, false, false];
  int selectedIndex = -1;
  List<String> imageUrls = [];
  List<String> bannerid = [];
  List<bool> bannerstatus = [];
  bool isLoading = true;
  String selected_banner_id = "";
  void showToast() {
    Fluttertoast.showToast(
      msg: 'Images applied successfully!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }

  Future<void> fetchBannerImages() async {
    final response = await http.get(Uri.parse('https://eatathome.in/app/api/kitchen-banners'),
      headers: {
        'Authorization': 'Bearer ${storage.read('api_token_login')}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      List<String> urls = [];
      List<String> banners = [];
      List<bool> banner_status = [];
      for (var item in data) {
        urls.add(item['url']);
        banners.add(item['id']);
        banner_status.add(item['status']);
      }
      for (var i = 0 ; i < banner_status.length;i++){
        setState(() {
          if(banner_status[i])
          selectedIndex = i;
        });
      }
      setState(() {
        imageUrls = urls;
        bannerid = banners;
        bannerstatus = banner_status;
        isLoading = false;
      });
      print(imageUrls);
    } else {
      throw Exception('Failed to load banner images');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBannerImages();
  }

  Future<void> uploadBanner() async {
    // Endpoint URL
    var url = Uri.parse('https://eatathome.in/app/api/kitchen/kitchen-banners-set');

    // Create multipart request
    var request = http.MultipartRequest('POST', url);
    print(storage.read('api_token_login'));
    // Add headers
    request.headers['Authorization'] = 'Bearer ${storage.read('api_token_login')}';

    // Add banner id as a field
    request.fields['banner_id'] = selected_banner_id;

    // Send request
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print(responseBody);
      // Check the response status
      if (response.statusCode == 200) {
        Wid_Con.toastmsgg(msg: "Banner Image Applied", context: context);
        print('Banner uploaded successfully');
      } else {
        print('Failed to upload banner. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading banner: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: Wid_Con.App_Bar(
          leading: Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_outlined, color: red),
            ),
          ),
          titel: "Banner Images",
        ),
        body: isLoading ? _buildShimmerLoader() : _buildImageListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await uploadBanner();
           // Wid_Con.toastmsgg(msg: "Banner Image Applied", context: context);
          },
          backgroundColor: red,
          child: Icon(Icons.check,color: Colors.white,),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageListView() {
    return ListView.builder(
      itemCount: (imageUrls.length / 2).ceil(),
      itemBuilder: (BuildContext context, int index) {
        final int firstIndex = index * 2;
        final int secondIndex = firstIndex + 1;
        return Row(
          children: [
            Expanded(
              child: buildImageCard(firstIndex),
            ),
            SizedBox(width: 4),
            Expanded(
              child: secondIndex < imageUrls.length
                  ? buildImageCard(secondIndex)
                  : Container(),
            ),
          ],
        );
      },
    );
  }

  Widget buildImageCard(int index) {

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          isSelected[index] = !isSelected[index];
          selected_banner_id = bannerid[index];
        });
      },
      child: Card(
        elevation: isSelected[index] ? 4.0 : 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: selectedIndex == index ? Colors.redAccent : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrls[index],
                height: 100,
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
            if (selectedIndex == index)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
