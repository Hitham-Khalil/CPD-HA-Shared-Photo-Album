import 'package:flutter/material.dart';
import 'dart:io';

class PhotoDetailsScreen extends StatelessWidget {
  final String imagePath;

  const PhotoDetailsScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo Details")),
      body: Center(
        child: imagePath.isNotEmpty
            ? Image.file(File(imagePath))
            : const Text("No Image Selected"),
      ),
    );
  }
}
