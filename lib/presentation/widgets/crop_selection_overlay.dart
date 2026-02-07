import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';

class CropSelectionOverlay extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(Rect) onConfirm;

  const CropSelectionOverlay({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<CropSelectionOverlay> createState() => _CropSelectionOverlayState();
}

class _CropSelectionOverlayState extends State<CropSelectionOverlay> {
  Offset? _startPos;
  Offset? _endPos;

  Rect? get _selectionRect {
    if (_startPos == null || _endPos == null) return null;
    return Rect.fromPoints(_startPos!, _endPos!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Dim
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              _startPos = details.localPosition;
              _endPos = details.localPosition;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _endPos = details.localPosition;
            });
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(150),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                if (_selectionRect != null)
                  Positioned.fromRect(
                    rect: _selectionRect!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Borders and handles
        if (_selectionRect != null)
          Positioned.fromRect(
            rect: _selectionRect!,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.stoxPrimary, width: 2),
              ),
            ),
          ),
        // Buttons
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: widget.onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.stoxText,
                ),
                child: Text(AppLocalizations.of(context)!.actionCancel),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _selectionRect != null && _selectionRect!.width > 10
                    ? () => widget.onConfirm(_selectionRect!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stoxPrimary,
                  foregroundColor: Colors.white,
                ),
                child: Text(AppLocalizations.of(context)!.actionScreenshot),
              ),
            ],
          ),
        ),
        // Tip text
        if (_startPos == null)
          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Card(
                color: Colors.black87,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(
                    '材料エリアをドラッグして選択してください',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
