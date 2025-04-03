import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

const backendurl = 'http://127.0.0.1:8000/vision/';

//  class ApiService {
//   static Future<void> sendToEdgeDetectionAPI(String base64Image) async {
//     final url = Uri.parse(backendurl);

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"image": base64Image}),
//       );

//       if (response.statusCode == 200) {
//         print("Frame processed successfully!");
//       } else {
//         print("Failed to process frame. Status Code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error sending data: $e");
//     }
//   }
// }


// Testing
// class ApiService {
//   static Future<void> sendToEdgeDetectionAPI(String base64Image) async {
//     // 🔥 Simulating a successful API call without Django
//     print("Encoded Base64 Image: $base64Image");

//     // Simulating API response delay
//     await Future.delayed(Duration(seconds: 2));

//     // Mock response
//     print("Mock API Response: Frame processed successfully!");
//   }
// } 

// -----------------------------------------------------------------------------------
// Managing with the backend

class EdgeDetectionService {
  static Future<Map<String, dynamic>> sendFrameToAPI(String base64Image) async {
    final url = Uri.parse(backendurl);  // Adjust IP as necessary
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        print("Frame processed successfully!");
        return jsonDecode(response.body);
      } else {
        print("Failed to process frame. Status Code: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error sending data: $e");
      return {};
    }
  }
}