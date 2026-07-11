import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ImageHelper {
  // Image par défaut (URL internet)
  static const String defaultImageUrl =
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=300&fit=crop';

  static bool isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  static bool isLocalImage(String path) {
    return !isNetworkImage(path) && path.isNotEmpty;
  }

  static ImageProvider getImageProvider(String path) {
    if (isNetworkImage(path)) {
      return NetworkImage(path);
    } else if (isLocalImage(path)) {
      final file = File(path);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        // Fallback sur l'URL par défaut
        return NetworkImage(defaultImageUrl);
      }
    } else {
      // Chemin vide ou invalide
      return NetworkImage(defaultImageUrl);
    }
  }

  static Widget buildImage(String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    // Si le chemin est vide, utiliser l'image par défaut
    final String imagePath = path.isEmpty ? defaultImageUrl : path;

    try {
      final provider = getImageProvider(imagePath);
      return Image(
        image: provider,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width ?? 80,
            height: height ?? 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(width, height);
        },
      );
    } catch (e) {
      return _buildPlaceholder(width, height);
    }
  }

  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width ?? 80,
      height: height ?? 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        color: AppColors.primary.withValues(alpha: 0.5),
        size: (width ?? 80) / 2,
      ),
    );
  }
}