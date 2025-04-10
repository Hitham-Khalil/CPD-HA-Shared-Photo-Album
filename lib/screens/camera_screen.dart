import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show basename;

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/${basename(image.path)}';
      await File(image.path).copy(imagePath);

      if (!mounted) return;
      Navigator.pop(context, imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Center(
        child: ElevatedButton(
          onPressed: _takePicture,
          child: const Text('Take a Picture'),
        ),
      ),
    );
  }
}
