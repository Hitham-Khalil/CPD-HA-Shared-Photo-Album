import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraService {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController!.initialize();
  }

  CameraController? get cameraController => _cameraController;

  Future<String?> takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return null;
    }

    try {
      final XFile image = await _cameraController!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now()}.png';
      final File savedImage = File(imagePath);
      await savedImage.writeAsBytes(await image.readAsBytes());
      return imagePath;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }

  void dispose() {
    _cameraController?.dispose();
  }
}
