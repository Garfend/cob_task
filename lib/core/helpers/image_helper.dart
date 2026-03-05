import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ImageHelper {
  ImageHelper._();

  static String get placeholderUrl => AppConstants.placeholderImage;

  static String getSourceLogoUrl(String? url) {
    if (url == null || url.isEmpty) {
      return placeholderUrl;
    }

    try {
      final uri = Uri.parse(url);
      final domain = uri.host.replaceFirst('www.', '');
      return AppConstants.getSourceLogoUrl(domain);
    } catch (e) {
      return placeholderUrl;
    }
  }

  static String getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholderUrl;
    }
    return imageUrl;
  }

  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme) return false;

      final path = uri.path.toLowerCase();
      return path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png') ||
          path.endsWith('.gif') ||
          path.endsWith('.webp') ||
          path.endsWith('.bmp');
    } catch (e) {
      return false;
    }
  }

  static int getSourceAvatarColor(String sourceName) {
    // Generate a consistent color based on the source name
    int hash = 0;
    for (int i = 0; i < sourceName.length; i++) {
      hash = sourceName.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return hash;
  }

  static String getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  static Color getAvatarColor(String sourceName) {
    // Generate a consistent color based on the source name
    final hash = getSourceAvatarColor(sourceName);

    // Convert hash to a color
    final colors = [
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFD32F2F), // Red
      const Color(0xFFF57C00), // Orange
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFF0097A7), // Cyan
      const Color(0xFFC2185B), // Pink
      const Color(0xFF5D4037), // Brown
    ];

    return colors[hash.abs() % colors.length];
  }
}
