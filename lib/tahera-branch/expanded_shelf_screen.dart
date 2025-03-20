import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class ExpandedShelfScreen extends StatelessWidget {
  final String shelfName;
  final String streamUrl; // Use your MJPEG stream URL here

  const ExpandedShelfScreen({
    Key? key,
    required this.shelfName,
    required this.streamUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shelfName),
      ),
      body: Center(
        child: Mjpeg(
          stream: streamUrl,
          isLive: true,
          // Optionally, adjust width, height, etc.
          // width: 300,
          // height: 200,
          error: (context, error, stackTrace) {
            return const Text('Error loading stream');
          },
        ),
      ),
    );
  }
}