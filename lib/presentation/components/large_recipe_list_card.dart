import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class LargeRecipeListCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String description;
  final String sourceInfo;
  final VoidCallback onTap;

  const LargeRecipeListCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.description,
    required this.sourceInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stoxBorder),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-width Image
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                  ),
                )
              else
                _buildPlaceholder(),
                
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Larger font size for emphasis
                          color: AppColors.stoxText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Source Info
                    Row(
                      children: [
                        const Icon(Icons.language,
                            size: 14, color: AppColors.stoxPrimary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sourceInfo,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.stoxSubText),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.stoxSubText),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: const Icon(Icons.restaurant, color: Colors.grey, size: 48),
    );
  }
}
