import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:convert';
import 'api_service.dart';

class CameraService {
  late CameraController _cameraController;
  bool _isStreaming = false;
  Timer? _frameTimer;

  CameraController get cameraController => _cameraController;

  Future<void> initializeCamera(List<CameraDescription> cameras) async {
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
  }

// changing time
void startFrameStreaming({required Function(Map<String, dynamic>) onFrameProcessed}) {
  _isStreaming = true;
  _frameTimer = Timer.periodic(Duration(milliseconds: 500), (timer) { //seconds: 1 milliseconds: 100
    if (_isStreaming) {
      _captureFrame(onFrameProcessed);
    }
  });
}

  void stopFrameStreaming() {
    _isStreaming = false;
    _frameTimer?.cancel();
  }

  Future<void> _captureFrame(Function(Map<String, dynamic>) onFrameProcessed) async {
    try {
      final XFile frame = await _cameraController.takePicture();
      final bytes = await frame.readAsBytes();
      String base64Image = base64Encode(bytes);

      // Send to API
      final response = await EdgeDetectionService.sendFrameToAPI(base64Image);

      if (response.isNotEmpty) {
      print("✅ API Response Received:"); // Check if this prints
      onFrameProcessed(response);
      } else {
        print("❌ No response data received from API.");
      }
    } catch (e) {
      print("Error capturing frame: $e");
    }
  }

  void dispose() {
    _cameraController.dispose();
    stopFrameStreaming();
  }
}
