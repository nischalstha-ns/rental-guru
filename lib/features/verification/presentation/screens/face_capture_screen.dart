
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen({super.key});
  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}
class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  bool _captured = false;
  List<CameraDescription>? _cameras;

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras!.first, ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void initState() { super.initState(); _initCamera(); }
  @override
  void dispose() { _controller?.dispose(); super.dispose(); }

  Future<void> _capture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    await _controller!.takePicture();
    setState(() => _captured = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(appBar: AppBar(title: const Text('Face Capture')),
      body: Stack(children: [
        CameraPreview(_controller!),
        Positioned(bottom: 32, left: 0, right: 0, child: Center(child: Column(children: [
          if (!_captured) FilledButton.icon(onPressed: _capture, icon: const Icon(Icons.camera_alt), label: const Text('Capture Face')),
          if (_captured) FilledButton(onPressed: () => context.push(RouteName.reviewSubmission), child: const Text('Review Submission')),
        ]))),
      ]),
    );
  }
}
