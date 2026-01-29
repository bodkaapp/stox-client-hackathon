import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;
  final Color? borderColor;
  final bool isAdd;
  final VoidCallback? onTap;

  const CircleActionButton({
    super.key,
    required this.icon,
    this.backgroundColor = Colors.white,
    required this.contentColor,
    this.borderColor,
    this.isAdd = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final actualBg = isAdd ? AppColors.stoxPrimary : backgroundColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: actualBg,
          shape: BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: isAdd
              ? [
                  BoxShadow(
                    color: actualBg.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  )
                ],
        ),
        child: Icon(icon, color: contentColor, size: 20),
      ),
    );
  }
}
