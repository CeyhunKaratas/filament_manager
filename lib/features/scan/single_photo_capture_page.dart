import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';

class SinglePhotoCaptureRage extends StatefulWidget {
  const SinglePhotoCaptureRage({super.key});

  @override
  State<SinglePhotoCaptureRage> createState() => _SinglePhotoCaptureRageState();
}

class _SinglePhotoCaptureRageState extends State<SinglePhotoCaptureRage> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isTakingPhoto = false;

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
      if (mounted) {
        Navigator.of(context).pop<String>(file.path);
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      if (mounted) {
        setState(() => _isTakingPhoto = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller == null) {
      return Scaffold(body: Center(child: Text(strings.cameraInitFailed)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            Positioned.fill(child: CameraPreview(_controller!)),

            // Top instruction
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Text(
                strings.takePhotoInstruction,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            // Capture button
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Center(
                child: GestureDetector(
                  onTap: _isTakingPhoto ? null : _takePhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: _isTakingPhoto ? Colors.grey : Colors.transparent,
                    ),
                    child: _isTakingPhoto
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
