import 'package:flutter/material.dart';

class ShelfCard extends StatelessWidget {
  final String shelfName;
  final VoidCallback onTap;

  const ShelfCard({
    Key? key,
    required this.shelfName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shelfName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.fullscreen,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}