import 'dart:io';
import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onDelete;

  const PhotoCard({
    super.key,
    required this.imagePath,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty || !File(imagePath).existsSync()) {
      return const Center(child: Text("No image available"));
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Captured Image",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
