import 'package:flutter/material.dart';

class ExpandedShelfScreen extends StatelessWidget {
  final String shelfName;
  final String imageAssetPath;

  const ExpandedShelfScreen({
    Key? key,
    required this.shelfName,
    required this.imageAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shelfName),
      ),
      body: Center(
        child: Image.asset(
          imageAssetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
