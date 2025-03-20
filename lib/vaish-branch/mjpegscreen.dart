import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class MjpegCameraScreen extends StatelessWidget {
  const MjpegCameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fridge Camera Stream")),
      body: Center(
        child: Mjpeg(
          stream: 'http://10.115.0.140:8081/picamera',
        ),
      ),
    );
  }
}