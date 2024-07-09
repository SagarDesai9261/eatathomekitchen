import 'dart:io';

import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _capturedImage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FaceCamera example app'),
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height -200,
                child: SmartFaceCamera(
                  autoCapture: true,
                  showControls: true,
                  showCaptureControl: false,
                  showFlashControl: false,
                  showCameraLensControl: false,
                  autoDisableCaptureControl: true,
                  indicatorShape: IndicatorShape.square,
                  defaultCameraLens: CameraLens.front,
                  message: 'Center your face in the square',
                  lensControlIcon: Container(
                    height: 80,
                    width: 300,
                    color: Colors.red,
                  ),
                  onCapture: (File? image){
                  },
                ),
              ),
              SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(onPressed: (){}, child: Text("Capture")))
            ],
          )),
    );
  }

  Widget _message(String msg) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
    child: Text(msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
  );
}