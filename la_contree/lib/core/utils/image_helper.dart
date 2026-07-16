import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';

class ImageHelper {
  static const String defaultImageUrl =
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=300&fit=crop';

  static bool isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  static bool isLocalImage(String path) {
    return !isNetworkImage(path) && path.isNotEmpty;
  }

  static Widget buildImage(String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    double? cacheWidth, 
    double? cacheHeight, 
  }) {
    final String imagePath = path.isEmpty ? defaultImageUrl : path;

    if (isNetworkImage(imagePath)) {
      // CachedNetworkImage pour le cache
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        cacheKey: imagePath,
        memCacheWidth: cacheWidth?.toInt() ?? 400,
        memCacheHeight: cacheHeight?.toInt() ?? 300,
        placeholder: (context, url) => _buildPlaceholder(width, height),
        errorWidget: (context, url, error) => _buildPlaceholder(width, height),
      );
    } else if (isLocalImage(imagePath)) {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth?.toInt() ?? 400,
        cacheHeight: cacheHeight?.toInt() ?? 300,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(width, height);
        },
      );
    } else {
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