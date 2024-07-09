import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Constants/Widget.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function(XFile) onPictureTaken;

  CameraScreen({required this.cameras, required this.onPictureTaken});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[1], // Assuming you want to use the first camera in the list
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<PermissionStatus> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,color:Colors.black),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(child: CameraPreview(_controller)),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double?>(5),
                        minimumSize:
                        MaterialStateProperty.all<Size?>(const Size(200, 45)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        var cameraPermissionStatus =
                        await _requestCameraPermission();
                        if (cameraPermissionStatus.isGranted) {
                          try {
                            await _initializeControllerFuture;
                            final XFile picture =
                            await _controller.takePicture();
                            widget.onPictureTaken(picture);
                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          // Fluttertoast.showToast(
                          //   msg: 'Camera permission not granted',
                          //   fontSize: 16,
                          //   backgroundColor: Colors.black,
                          //   gravity: ToastGravity.BOTTOM,
                          //   textColor: Colors.white,
                          // );
                          Wid_Con.toastmsgr(context: context,msg:'Camera permission not granted');
                        }
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.camera,color: Colors.black,),
                          Text('Click Picture',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
