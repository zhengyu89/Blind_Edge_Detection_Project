import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/camera_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

List<CameraDescription> cameras = [];

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraService _cameraService = CameraService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isStreaming = false;
  List<Map<String, dynamic>> boundingBoxes = [];
  String warningMessage = '';
  String audioUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    await _cameraService.initializeCamera(cameras);
    setState(() {
      _isInitialized = true;
    });
  }

  // This function processes the API response, updating bounding boxes, warning messages, and playing audio if provided.
  void _processApiResponse(Map<String, dynamic> response) {
  setState(() {
    boundingBoxes = response['objects']?.map<Map<String, dynamic>>((obj) {
      return {
        "name": obj["name"],
        "bounding_box": obj["bounding_box"]
      };
    }).toList() ?? [];

    warningMessage = response['warning_message'] ?? '';

    String base64Audio = response['audio_base64'] ?? '';
    if (base64Audio.isNotEmpty) {
      _playAudio(base64Audio);
      print("✅ Audio played successfully.");
    }

      print("✅ API response processed successfully.");
      print("Bounding Boxes: $boundingBoxes");
      print("Warning Message: $warningMessage");

  });
  }

  // Future<void> _playAudio(String base64Audio) async {
  //   try {
  //     // Decode base64 audio to bytes
  //     List<int> audioBytes = base64Decode(base64Audio);

  //     // Get temporary directory for saving audio
  //     Directory tempDir = await getTemporaryDirectory();
  //     String tempPath = '${tempDir.path}/temp_audio.mp3';

  //     // Write the bytes to the temporary file
  //     File audioFile = File(tempPath);
  //     await audioFile.writeAsBytes(audioBytes);

  //     // Play the audio from the local file
  //     await _audioPlayer.play(DeviceFileSource(audioFile.path));
  //   } catch (e) {
  //     print("Error playing audio: $e");
  //   }
  // }

  Future<void> _playAudio(String base64Audio) async {
  try {
    Uint8List audioBytes = base64Decode(base64Audio);
    final directory = await getTemporaryDirectory();
    final audioFile = File('${directory.path}/audio.mp3');

    await audioFile.writeAsBytes(audioBytes);

    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(DeviceFileSource(audioFile.path));

    print("✅ Audio playback successful!");
  } catch (e) {
    print("❌ Error playing audio: $e");
  }
}


  @override
  void dispose() {
    _cameraService.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading Camera...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Edge Detection Camera")),
      body: Stack(
        children: [
          CameraPreview(_cameraService.cameraController),
          ...boundingBoxes.map((box) {
            // Extract the bounding box coordinates
            List<dynamic> coordinates = box['bounding_box'];
            double left = coordinates[0]['x'].toDouble();
            double top = coordinates[0]['y'].toDouble();
            double right = coordinates[2]['x'].toDouble();
            double bottom = coordinates[2]['y'].toDouble();

            return Positioned(
              left: left,
              top: top,
              child: Container(
                width: right - left,
                height: bottom - top,
                decoration:  BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              )
            );
          }).toList(),
          if (warningMessage.isNotEmpty)
            Positioned(
              bottom: 80,
              left: 20,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black54,
                child: Text(
                  warningMessage,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isStreaming = !_isStreaming;
                  if (_isStreaming) {
                    _cameraService.startFrameStreaming(onFrameProcessed: _processApiResponse);
                  } else {
                    _cameraService.stopFrameStreaming();
                  }
                });
              },
              child: Icon(_isStreaming ? Icons.pause : Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}
