// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras![0], ResolutionPreset.low,);
    await _cameraController?.initialize();
    await _cameraController?.lockCaptureOrientation(DeviceOrientation.portraitUp);
    await _cameraController?.setZoomLevel(0.05);
    await _cameraController?.setFocusMode(FocusMode.auto);
    setState(() {});
  }

  Future<void> captureImage() async {
  if (_cameraController!.value.isInitialized) {
    final image = await _cameraController!.takePicture();
    await analyzeImage(image.path);
  }
}

Future<void> analyzeImage(String imagePath) async {
  final bytes = await File(imagePath).readAsBytes();
  final base64Image = base64Encode(bytes);

  // Send image to API for analysis
  final response = await http.post(
    Uri.parse('https://api.caloriemama.ai/v1/food_recognition'),
    headers: {
      'Authorization': 'Bearer YOUR_API_KEY',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'image': base64Image,
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print("Food Info: ${result['data']}");
  } else {
    print("Error: ${response.statusCode}");
  }
}

Future<void> _focusAtPoint(Offset offset, Size screenSize) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    // Calculate the relative focus point (0.0 - 1.0)
    double x = offset.dx / screenSize.width;
    double y = offset.dy / screenSize.height;

    try {
      await _cameraController?.setFocusPoint(Offset(x, y));
      print("Focus set at: $x, $y");
    } catch (e) {
      print("Error setting focus point: $e");
    }
  }

Future<void> _captureImage() async {
    try {
      if (_cameraController!.value.isInitialized) {
        final XFile image = await _cameraController!.takePicture(); // Capture the image
        print('Image captured at: ${image.path}');
        _showCapturedImage(image.path); // Show or process the captured image
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  void _showCapturedImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayImageScreen(imagePath: imagePath),
      ),
    );
  }


  
  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Integration")),
      body: Stack(
        children: [
          GestureDetector(
        onTapDown: (TapDownDetails details) {
          // Focus on the point where the user taps
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          _focusAtPoint(localPosition, renderBox.size);
        },
        child: CameraPreview(_cameraController!),
      ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _captureImage, // Call the capture image method
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;

  const DisplayImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Captured Image")),
      body: Center(
        child: Image.file(File(imagePath)), // Display the captured image
      ),
    );
  }
}