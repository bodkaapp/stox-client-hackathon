import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class IngredientPipView extends StatefulWidget {
  final Uint8List imageData;
  final VoidCallback onClose;

  const IngredientPipView({
    super.key,
    required this.imageData,
    required this.onClose,
  });

  @override
  State<IngredientPipView> createState() => _IngredientPipViewState();
}

class _IngredientPipViewState extends State<IngredientPipView> {
  Offset _offset = const Offset(20, 100);
  double _width = 200.0;
  double _height = 150.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _offset += details.delta;
                });
              },
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 5.0,
                  child: Image.memory(
                    widget.imageData,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 16, color: AppColors.stoxText),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: widget.onClose,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _width = (_width + details.delta.dx).clamp(100.0, 400.0);
                    _height = (_height + details.delta.dy).clamp(100.0, 600.0);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.unfold_more, size: 20, color: AppColors.stoxSubText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
