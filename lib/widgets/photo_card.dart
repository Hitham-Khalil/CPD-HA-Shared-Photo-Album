import 'dart:io';
import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  final String imagePath;

  const PhotoCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Check if the imagePath is valid
    if (imagePath.isEmpty || !File(imagePath).existsSync()) {
      return const Center(
        child: Text("No image available"),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Captured Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
