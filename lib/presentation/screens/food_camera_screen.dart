
import 'dart:io';
import 'dart:async'; // Added for Timer
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart'; // Added for context.go
// import 'package:volume_controller/volume_controller.dart'; // Removed volume_controller
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'photo_viewer_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/photo_analysis.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../infrastructure/repositories/drift_photo_analysis_repository.dart';

class FoodCameraScreen extends ConsumerStatefulWidget {
  final bool createMealPlanOnCapture;

  const FoodCameraScreen({super.key, this.createMealPlanOnCapture = false});

  @override
  ConsumerState<FoodCameraScreen> createState() => _FoodCameraScreenState();
}

class _FoodCameraScreenState extends ConsumerState<FoodCameraScreen> with WidgetsBindingObserver {
  // ... existing fields ...
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isInitializing = false; 
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  
  FlashMode _flashMode = FlashMode.off;

  bool _showFilterIndicator = false;
  bool _isBlurEnabled = false;
  Timer? _filterIndicatorTimer;
  
  bool _showShutterFlash = false;

  int _selectedFilterIndex = 0;
  File? _lastCapturedPhoto;

  final List<FilterItem> _filters = [
    FilterItem(name: 'Original', matrix: null),
    FilterItem(name: 'Fresh', matrix: [ // YU1
      1.2, 0.0, 0.0, 0.0, 10.0,
      0.0, 1.1, 0.0, 0.0, 5.0,
      0.0, 0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
    FilterItem(name: 'Warm', matrix: [ // Juno
      1.3, 0.0, 0.0, 0.0, 20.0,
      0.0, 1.15, 0.0, 0.0, 10.0,
      0.0, 0.0, 0.9, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
    FilterItem(name: 'Cool', matrix: [ // Lark
      0.9, 0.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 1.3, 0.0, 20.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
     FilterItem(name: 'Sweet', matrix: [
      1.2, 0.0, 0.0, 0.0, 30.0,
      0.0, 1.0, 0.0, 0.0, 10.0,
      0.0, 0.0, 1.1, 0.0, 30.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
    FilterItem(name: 'Mono', matrix: [
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
    _enableVolumeListener();
    _initializeCamera();
  }

  // ... platform methods ...
  static const platform = MethodChannel('app.bodka.stox/volume');

  Future<void> _enableVolumeListener() async {
    try {
      if (Platform.isAndroid) {
         await platform.invokeMethod('enableVolumeListener');
         platform.setMethodCallHandler((call) async {
           if (call.method == 'onVolumeBtnPressed') {
             _takePicture();
           }
         });
      }
    } catch (e) {
      debugPrint("Failed to enable volume listener: '$e'.");
    }
  }

  Future<void> _disableVolumeListener() async {
    try {
      if (Platform.isAndroid) {
         await platform.invokeMethod('disableVolumeListener');
         platform.setMethodCallHandler(null);
      }
    } catch (e) {
      debugPrint("Failed to disable volume listener: '$e'.");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disableVolumeListener();
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
    if (!mounted) {
        _isInitializing = false;
        return;
    }
    try {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.cameraPermissionRequired)), // カメラの権限が必要です
          );
          Navigator.of(context).pop();
        }
        return;
      }
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.veryHigh, 
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.jpeg : ImageFormatGroup.bgra8888,
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
            SnackBar(content: Text(AppLocalizations.of(context)!.cameraNotFound)), // カメラが見つかりません
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

  // ... build method ...
  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    
    final size = MediaQuery.of(context).size;
    var cameraAspectRatio = _controller!.value.aspectRatio;
    if (size.width < size.height && cameraAspectRatio > 1) { 
       cameraAspectRatio = 1 / cameraAspectRatio;
    }
    var scale = 1.0;
    if (cameraAspectRatio > 1) {
       scale = cameraAspectRatio; 
    } else {
       scale = 1 / cameraAspectRatio; 
    }

    final currentMatrix = _filters[_selectedFilterIndex].matrix;

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
          children: [
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
            SizedBox(
              width: size.width,
              height: size.width,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                   RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: Container(
                      color: Colors.black,
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
                                   if (currentMatrix != null)
                                     ColorFiltered(
                                       colorFilter: ColorFilter.matrix(currentMatrix),
                                       child: cameraWidget,
                                     )
                                   else
                                     cameraWidget,
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
                   IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: _showShutterFlash ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                   ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
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
      case FlashMode.off: nextMode = FlashMode.torch; break;
      case FlashMode.torch: nextMode = FlashMode.auto; break;
      case FlashMode.auto: nextMode = FlashMode.off; break;
      default: nextMode = FlashMode.off;
    }
    try {
      await _controller!.setFlashMode(nextMode);
      setState(() { _flashMode = nextMode; });
    } catch (e) {
      debugPrint('Error setting flash mode: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      setState(() { _showShutterFlash = true; });
      Future.delayed(const Duration(milliseconds: 100), () {
        if(mounted) { setState(() { _showShutterFlash = false; }); }
      });
      
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = await File('${tempDir.path}/stox_food_$timestamp.png').create();
      await file.writeAsBytes(pngBytes);

      await Gal.putImage(file.path, album: 'STOX');

      // Auto-Save Logic
      if (widget.createMealPlanOnCapture) {
        await _saveToMealPlan(file.path);
      }



      if (mounted) {
         Navigator.of(context).push(
           MaterialPageRoute(
             builder: (_) => PhotoViewerScreen(
               filePath: file.path,
               isNewCapture: true,  // Indicate this is a fresh capture
             ),
           ),
         );
      }
    } catch (e) {
      debugPrint('Error saving photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorSaveFailed}: $e')), // 保存に失敗しました
        );
      }
    }
  }



  Future<void> _saveToMealPlan(String photoPath) async {
    try {
      final repo = await ref.read(mealPlanRepositoryProvider.future);
      final now = DateTime.now();
      
      final mealPlan = MealPlan(
        id: const Uuid().v4(),
        recipeId: '', // No recipe
        date: now,
        mealType: _getMealTypeFromTime(now),
        isDone: true,
        completedAt: now,
        photos: [photoPath],
      );
      
      await repo.save(mealPlan);
    } catch (e) {
      debugPrint('Error auto-saving meal plan: $e');
    }
  }

  MealType _getMealTypeFromTime(DateTime time) {
    final hour = time.hour;
    if (hour >= 4 && hour < 10) return MealType.breakfast;
    if (hour >= 10 && hour < 15) return MealType.lunch;
    if (hour >= 15 && hour < 18) return MealType.snack;
    if (hour >= 18 && hour < 23) return MealType.dinner;
    return MealType.other;
  }
  
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
  }
} // End of State
// FilterItem class remains...

class FilterItem {
  final String name;
  final List<double>? matrix;

  FilterItem({required this.name, required this.matrix});
}
