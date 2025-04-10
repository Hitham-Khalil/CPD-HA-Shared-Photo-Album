import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_photo_album/widgets/photo_card.dart';
import 'package:shared_photo_album/screens/photo_details_screen.dart'; // Make sure this import is here

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPaths = prefs.getStringList('saved_images') ?? [];
    setState(() {
      imagePaths = savedPaths;
    });
  }

  void _navigateToCameraScreen() async {
    final result = await Navigator.pushNamed(context, '/camera');
    if (result != null && result is String) {
      setState(() {
        imagePaths.add(result);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('saved_images', imagePaths);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: imagePaths.isEmpty
          ? const Center(child: Text('No images yet.'))
          : ListView.builder(
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                final path = imagePaths[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhotoDetailsScreen(imagePath: path),
                      ),
                    );
                  },
                  child: PhotoCard(imagePath: path),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCameraScreen,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
