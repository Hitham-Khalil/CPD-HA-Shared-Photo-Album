import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_photo_album/widgets/photo_card.dart';
import 'package:shared_photo_album/screens/photo_details_screen.dart';
import 'dart:io'; // for deleting files
import 'package:flutter_local_notifications/flutter_local_notifications.dart';  // Import the notification plugin

class HomeScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;  // Pass notification plugin

  const HomeScreen({Key? key, required this.flutterLocalNotificationsPlugin}) : super(key: key);

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

      // Show notification when a photo is taken
      _showNotification('New photo taken and added to your album');
    }
  }

  void _deleteImage(int index) async {
    final path = imagePaths[index];

    setState(() {
      imagePaths.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_images', imagePaths);

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    // Show notification when a photo is deleted
    _showNotification('Photo deleted from your album');
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'photo_channel', // Channel ID
      'Photo Notifications', // Channel Name
      channelDescription: 'Notifications for photo actions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await widget.flutterLocalNotificationsPlugin.show(
      0,
      'Photo Update',
      message,
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
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
                  child: PhotoCard(
                    imagePath: path,
                    onDelete: () => _deleteImage(index),
                  ),
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
