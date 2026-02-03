
import 'dart:io';
import 'dart:async'; // Added for Timer
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart'; // Added for context.go
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'photo_viewer_screen.dart';

class FoodCameraScreen extends StatefulWidget {
  const FoodCameraScreen({super.key});

  @override
  State<FoodCameraScreen> createState() => _FoodCameraScreenState();
}

class _FoodCameraScreenState extends State<FoodCameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isInitializing = false; // Guard for parallel inits
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  
  // Flash mode state
  FlashMode _flashMode = FlashMode.off;

  // Filter Indicator State
  bool _showFilterIndicator = false;
  bool _isBlurEnabled = false;
  Timer? _filterIndicatorTimer;

  // Filter Selection
  int _selectedFilterIndex = 0;
  File? _lastCapturedPhoto;

  // final FocusNode _focusNode = FocusNode(); // Removed FocusNode

  final List<FilterItem> _filters = [
    FilterItem(name: 'Original', matrix: null),
    FilterItem(name: 'Fresh (YU1)', matrix: [
      1.2, 0.0, 0.0, 0.0, 10.0,
      0.0, 1.1, 0.0, 0.0, 5.0,
      0.0, 0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]), // Strongly bright and warm
    FilterItem(name: 'Warm (Juno)', matrix: [ // Strong amber/warm
      1.3, 0.0, 0.0, 0.0, 20.0,
      0.0, 1.15, 0.0, 0.0, 10.0,
      0.0, 0.0, 0.9, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
    FilterItem(name: 'Cool (Lark)', matrix: [ // Strong blue/cold
      0.9, 0.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 1.3, 0.0, 20.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
     FilterItem(name: 'Sweet', matrix: [ // Strong Pink
      1.2, 0.0, 0.0, 0.0, 30.0,
      0.0, 1.0, 0.0, 0.0, 10.0,
      0.0, 0.0, 1.1, 0.0, 30.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
    FilterItem(name: 'Mono', matrix: [ // Black & White for testing
      0.33, 0.33, 0.33, 0.0, 0.0,
      0.33, 0.33, 0.33, 0.0, 0.0,
      0.33, 0.33, 0.33, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    _initializeCamera();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.audioVolumeUp ||
          event.physicalKey == PhysicalKeyboardKey.audioVolumeDown) {
          // Trigger shutter
          _takePicture();
          return true; // Stop propagation (prevent volume change)
      }
    }
    return false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
      if (mounted) {
         setState(() => _isCameraInitialized = false);
      }
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;
    _isInitializing = true;

    // Small delay to ensure lifecycle stability on quick launch
    if (!mounted) {
        _isInitializing = false;
        return;
    }

    try {
      // Request permissions
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('カメラの権限が必要です')),
          );
          Navigator.of(context).pop();
        }
        return; // Finally block will handle flag reset
      }

      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.veryHigh, 
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid 
              ? ImageFormatGroup.jpeg 
              : ImageFormatGroup.bgra8888,
        );

        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } else {
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('カメラが見つかりません')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    } finally {
      if (mounted) {
         _isInitializing = false;
      }
    }
  }

  // ... _toggleFlash, _takePicture (keep as is)

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    


    final size = MediaQuery.of(context).size;
     
    // Determine the scale to cover the square area
    var cameraAspectRatio = _controller!.value.aspectRatio;
    // On many devices, aspect ratio is < 1 for portrait (e.g. 9/16).
    // If it's inverted structure (width/height > 1), we flip it.
    if (size.width < size.height && cameraAspectRatio > 1) { 
       cameraAspectRatio = 1 / cameraAspectRatio;
    }

    var scale = 1.0;
    if (cameraAspectRatio > 1) {
       scale = cameraAspectRatio; 
    } else {
       // Portrait sensor (e.g. 0.75)
       // To fill 1.0, we need to scale by 1/ratio?
       // Actually CameraPreview maintains aspect ratio.
       scale = 1 / cameraAspectRatio; 
    }

    final currentMatrix = _filters[_selectedFilterIndex].matrix;

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          // ... rest of the body
          child: Column(
          children: [
             // 1. Top Controls
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.pinkAccent, size: 28),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop(_lastCapturedPhoto?.path);
                      } else {
                        // If launched via Quick Action (no history), go to Home
                        context.go('/');
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _flashMode == FlashMode.off ? Icons.flash_off : 
                      _flashMode == FlashMode.torch ? Icons.flash_on : Icons.flash_auto,
                      color: Colors.pinkAccent, 
                      size: 28
                    ),
                    onPressed: _toggleFlash,
                  ),
                ],
              ),
            ),
            
            const Spacer(),

            // 2. Square Camera View Area
            SizedBox(
              width: size.width,
              height: size.width,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                   // Layer A: Capture Boundary (Camera + Filters + Watermark)
                   RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: Container(
                      color: Colors.black, // Background for transparency handling
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                               final cameraWidget = OverflowBox(
                                  maxWidth: double.infinity,
                                  maxHeight: double.infinity,
                                  child: SizedBox(
                                    width: size.width,
                                    height: size.width * scale,
                                    child: CameraPreview(_controller!),
                                  ),
                                );
        
                               return Stack(
                                 fit: StackFit.expand,
                                 children: [
                                   // Sharp Layer
                                   if (currentMatrix != null)
                                     ColorFiltered(
                                       colorFilter: ColorFilter.matrix(currentMatrix),
                                       child: cameraWidget,
                                     )
                                   else
                                     cameraWidget,
        
                                   // Blur Layer
                                   if (_isBlurEnabled)
                                     ShaderMask(
                                       shaderCallback: (rect) {
                                         return const RadialGradient(
                                           center: Alignment.center,
                                           radius: 0.9,
                                           colors: [Colors.transparent, Colors.black],
                                           stops: [0.25, 0.75],
                                         ).createShader(rect);
                                       },
                                       blendMode: BlendMode.dstIn,
                                       child: ImageFiltered(
                                         imageFilter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                         child: currentMatrix != null
                                             ? ColorFiltered(
                                                 colorFilter: ColorFilter.matrix(currentMatrix),
                                                 child: cameraWidget,
                                               )
                                             : cameraWidget,
                                       ),
                                     ),
                                 ],
                               );
                            }
                          ),
                          
                           // Watermark (Inside RepaintBoundary to be captured)
                           Positioned(
                             right: 12,
                             bottom: 12,
                             child: Opacity(
                               opacity: 0.8,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                    const Text(
                                     'STOX',
                                     style: TextStyle(
                                       fontFamily: 'Inter',
                                       fontSize: 18, 
                                       fontWeight: FontWeight.w900, 
                                       color: Colors.white,
                                       letterSpacing: 1.5,
                                       shadows: [
                                         Shadow(
                                           blurRadius: 4.0,
                                           color: Colors.black45,
                                           offset: Offset(1.0, 1.0),
                                         ),
                                       ]
                                     ),
                                   ),
                                   Text(
                                     _getFormattedDate(),
                                     style: const TextStyle(
                                       fontSize: 8,
                                       color: Colors.white,
                                       fontWeight: FontWeight.w600,
                                       shadows: [
                                         Shadow(
                                           blurRadius: 2.0,
                                           color: Colors.black45,
                                           offset: Offset(0.5, 0.5),
                                         ),
                                       ]
                                     ),
                                   )
                                 ],
                               ),
                             ),
                           ),
                        ],
                      ),
                    ),
                   ),

                   // Layer B: UI Overlays (Not captured)
                   
                   // Blur Toggle
                   Positioned(
                     left: 16,
                     bottom: 16,
                     child: GestureDetector(
                       onTap: () {
                         setState(() {
                           _isBlurEnabled = !_isBlurEnabled;
                         });
                       },
                       child: Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                           color: _isBlurEnabled ? Colors.pinkAccent.withOpacity(0.8) : Colors.black54,
                           shape: BoxShape.circle,
                           border: Border.all(color: Colors.white, width: 1.5),
                         ),
                         child: const Icon(
                           Icons.blur_on,
                           color: Colors.white,
                           size: 24,
                         ),
                       ),
                     ),
                   ),

                   // Filter Indicator
                   if (_showFilterIndicator)
                     Center(
                       child: AnimatedOpacity(
                         opacity: _showFilterIndicator ? 1.0 : 0.0,
                         duration: const Duration(milliseconds: 300),
                         child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                           decoration: BoxDecoration(
                             color: Colors.black54,
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child: Text(
                             _filters[_selectedFilterIndex].name,
                             style: const TextStyle(
                               color: Colors.white,
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ),
                       ),
                     ),
                ],
              ),
            ),
          ),
            
            const Spacer(),
            
            // 3. Bottom Controls
            Column(
              children: [
                // Filter + Thumbnail Row
                SizedBox(
                  height: 90,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: _filters.length,
                          itemBuilder: (context, index) {
                            final filter = _filters[index];
                            final isSelected = index == _selectedFilterIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilterIndex = index;
                                  _showFilterIndicator = true;
                                });
                                _filterIndicatorTimer?.cancel();
                                _filterIndicatorTimer = Timer(const Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() {
                                      _showFilterIndicator = false;
                                    });
                                  }
                                });
                              },
                              child:  Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? Colors.pinkAccent : Colors.white24,
                                          width: isSelected ? 3 : 1,
                                        ),
                                        color: Colors.grey.shade900,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        filter.name.substring(0, 1),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      filter.name,
                                      style: TextStyle(
                                        color: isSelected ? Colors.pinkAccent : Colors.white54,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Thumbnail
                       Padding(
                         padding: const EdgeInsets.only(right: 16, left: 8),
                         child: GestureDetector(
                           onTap: () {
                             if (_lastCapturedPhoto != null) {
                               Navigator.of(context).push(
                                 MaterialPageRoute(
                                   builder: (_) => PhotoViewerScreen(filePath: _lastCapturedPhoto!.path),
                                 ),
                               );
                             }
                           },
                           child: Container(
                             width: 44,
                             height: 44,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(color: Colors.white38),
                               color: Colors.grey.shade900,
                               image: _lastCapturedPhoto != null ? DecorationImage(
                                 image: FileImage(_lastCapturedPhoto!),
                                 fit: BoxFit.cover,
                               ) : null,
                             ),
                             child: _lastCapturedPhoto == null ? const Icon(Icons.photo, color: Colors.white38, size: 20) : null,
                           ),
                         ),
                       ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Shutter Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    
    FlashMode nextMode;
    switch (_flashMode) {
      case FlashMode.off:
        nextMode = FlashMode.torch; // Continuous light is often better for food
        break;
      case FlashMode.torch:
        nextMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        nextMode = FlashMode.off;
        break;
      default:
        nextMode = FlashMode.off;
    }
    
    try {
      await _controller!.setFlashMode(nextMode);
      setState(() {
        _flashMode = nextMode;
      });
    } catch (e) {
      debugPrint('Error setting flash mode: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      // 1. Capture widget as image
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      // Capture at pixel ratio 3.0 for higher quality screen grab
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      // 2. Save to temp file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = await File('${tempDir.path}/stox_food_$timestamp.png').create();
      await file.writeAsBytes(pngBytes);

      // 3. Save to Gallery
      // Request storage permission if needed (handled by gal implicitly or we can check)
      // Note: Gal handles permissions internally for the most part, but we can wrap in try-catch
      await Gal.putImage(file.path, album: 'STOX');

      if (mounted) {
        setState(() {
          _lastCapturedPhoto = file;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('写真を保存しました')),
        );
      }
    } catch (e) {
      debugPrint('Error saving photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました: $e')),
        );
      }
    }
  }



  
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
  }
}

class FilterItem {
  final String name;
  final List<double>? matrix;

  FilterItem({required this.name, required this.matrix});
}
