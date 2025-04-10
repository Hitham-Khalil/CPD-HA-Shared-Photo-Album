import 'package:flutter/material.dart';
import 'package:shared_photo_album/widgets/photo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? imagePath;

  // Function to navigate to CameraScreen and get the image path
  void _navigateToCameraScreen() async {
    final result = await Navigator.pushNamed(context, '/camera');
    if (result != null && result is String) {
      setState(() {
        imagePath = result;  // Update image path when returning from CameraScreen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _navigateToCameraScreen,
              child: const Text('Go to Camera'),
            ),
            const SizedBox(height: 20),
            imagePath != null
                ? PhotoCard(imagePath: imagePath!)
                : const Text('No image taken'),
          ],
        ),
      ),
    );
  }
}
