import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show basename;
import 'package:firebase_storage/firebase_storage.dart';

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
      // Save locally
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/${basename(image.path)}';
      final File localFile = await File(image.path).copy(imagePath);

      // Upload to Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('photos/${basename(image.path)}');

        await storageRef.putFile(localFile);

        final String downloadUrl = await storageRef.getDownloadURL();
        print('Image uploaded. Download URL: $downloadUrl');
      } catch (e) {
        print('Failed to upload image: $e');
      }

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
