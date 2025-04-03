import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isLoading = false;
  List<Map<String, dynamic>> boundingBoxes = [];
  String warningMessage = '';
  String audioUrl = '';
  String lastWarningMessage = ''; // Store last warning message
  bool _isPlaying = false; // Prevent duplicate playback
  DateTime? _lastTtsTime; // Timestamp for last played message

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isLoading = true;
    });
    
    cameras = await availableCameras();
    await _cameraService.initializeCamera(cameras);
    
    setState(() {
      _isInitialized = true;
      _isLoading = false;
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

      DateTime now = DateTime.now();
      if (warningMessage != lastWarningMessage || _shouldPlayAgain(now)) {
        String base64Audio = response['audio_base64'] ?? '';
        if (base64Audio.isNotEmpty) {
          _playAudio(base64Audio);
          _lastTtsTime = now; // Update last playback time
          lastWarningMessage = warningMessage; // Store last warning message
          print("✅ Audio played successfully.");
        }
      }

      print("✅ API response processed successfully.");
      print("Bounding Boxes: $boundingBoxes");
      print("Warning Message: $warningMessage");
    });
  }

  // ✅ Function to check if audio should play again after 5 seconds
  bool _shouldPlayAgain(DateTime now) {
    if (_lastTtsTime == null) return true;
    return now.difference(_lastTtsTime!).inSeconds >= 5;
  }

  Future<void> _playAudio(String base64Audio) async {
    if (_isPlaying) return; // Prevent overlapping playback
    _isPlaying = true;

    try {
      Uint8List audioBytes = base64Decode(base64Audio);
      final directory = await getTemporaryDirectory();
      final audioFile = File('${directory.path}/audio.mp3');

      await audioFile.writeAsBytes(audioBytes);

      await _audioPlayer.play(DeviceFileSource(audioFile.path));

      print("✅ Audio playback successful!");
    } catch (e) {
      print("❌ Error playing audio: $e");
    } finally {
      _isPlaying = false; // Reset flag after playing
    }
  }

  void _openSettings() {
    // TODO: Implement settings page navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings page not implemented yet'))
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB89261),
        title: Text("HearWay", style: GoogleFonts.merriweather(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _isInitialized 
        ? _buildCameraView()
        : _buildLoadingView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 80, color: Colors.orange),
          SizedBox(height: 20),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          SizedBox(height: 20),
          Text(
            "Loading...",
            style:  GoogleFonts.karla(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        Center( //center
        // Camera Preview
        child: Container(
        // width: double.infinity, // Ensures full width
        width: MediaQuery.of(context).size.width * 0.95, //cut liao 0.9 jiu full screen
        height: MediaQuery.of(context).size.width * 0.95 * (16/9), // Full screen height size.height * (16/9)
        //margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CameraPreview(_cameraService.cameraController),
          ),
        ),
        ),
        
        // Bounding Boxes
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
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
              ),
            )
          );
        }).toList(),
        
        // Warning Message
        if (warningMessage.isNotEmpty)
          Positioned(
            bottom: 10,
            left: 00,
            right: 00,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(151, 0, 0, 0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                warningMessage,
                style: GoogleFonts.karla(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        
        // Loading Indicator when streaming
        if (_isStreaming && _isLoading)
          Center(
          //Positioned(
            //bottom: 10,
            //left: 0,
            //right: 0,
            child: Container(
              //margin: EdgeInsets.symmetric(horizontal: 50),
              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //padding: EdgeInsets.all(10),
              width: 50, // Circular size
              height: 50, // Circular size
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha((0.8 * 255).toInt()),
                //borderRadius: BorderRadius.circular(8),
                shape: BoxShape.circle
              ),
              child: Padding(
                //mainAxisAlignment: MainAxisAlignment.center,
                //children: [
                // Text(
                //    "Loading...",
                //    style: TextStyle(
                //      color: Colors.white,
                //      fontWeight: FontWeight.bold,
                //    ),
                //  ),
                //  SizedBox(width: 6),
                //  SizedBox(
                //    width: 80,
                //    height: 25,
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              //  ],
              ),
            ),
        //  ),
        
        // Start/Stop Button
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: _isStreaming ? Colors.red : Colors.orange,
              onPressed: () {
                setState(() {
                  _isStreaming = !_isStreaming;
                  _isLoading = _isStreaming;
                  if (_isStreaming) {
                    _cameraService.startFrameStreaming(onFrameProcessed: (response) {
                      _processApiResponse(response);
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  } else {
                    _cameraService.stopFrameStreaming();
                  }
                });
              },
              child: Icon(_isStreaming ? Icons.pause : Icons.play_arrow),
            ),
          ),
        ),
      ],
    );
  }
}

