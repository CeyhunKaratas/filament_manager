import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isTakingPhoto = false;

  final List<XFile> _capturedPhotos = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _controller = null;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isTakingPhoto) return;

    setState(() => _isTakingPhoto = true);

    try {
      final XFile file = await _controller!.takePicture();
      setState(() {
        _capturedPhotos.add(file);
      });
    } catch (_) {
      // test ekranı – sessiz geç
    } finally {
      if (mounted) setState(() => _isTakingPhoto = false);
    }
  }

  void _finishCapture() {
    Navigator.of(context).pop<List<XFile>>(List<XFile>.from(_capturedPhotos));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(Localizations.localeOf(context));

    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller == null) {
      return Scaffold(body: Center(child: Text(s.cameraInitFailed)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Kamera preview
            Positioned.fill(child: CameraPreview(_controller!)),

            // Üst talimat
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Text(
                s.scanCaptureInstruction,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            // Alt kontrol paneli
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Column(
                children: [
                  Text(
                    s.photosTaken(_capturedPhotos.length),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // FOTO ÇEK
                      GestureDetector(
                        onTap: _takePhoto,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                        ),
                      ),

                      // TAMAM
                      ElevatedButton(
                        onPressed: _finishCapture,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(s.doneUpper),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
