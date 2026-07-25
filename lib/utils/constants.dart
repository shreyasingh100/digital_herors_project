import 'package:flutter/material.dart';
import '../models/order.dart';

/// App-wide color constants.
class AppColors {
  AppColors._();

  // Background & surface
  static const Color scaffoldBg = Color(0xFF0F0F1E);
  static const Color cardBg = Color(0xFF1A1A2E);
  static const Color cardBgLight = Color(0xFF222240);
  static const Color surfaceOverlay = Color(0x1AFFFFFF);

  // Gradient
  static const Color gradientStart = Color(0xFF6C63FF);
  static const Color gradientMid = Color(0xFF3F8CFF);
  static const Color gradientEnd = Color(0xFF00D9A6);

  // Text
  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF9E9EB8);
  static const Color textMuted = Color(0xFF6B6B80);

  // Status colors
  static const Color statusPlaced = Color(0xFFAB7BFF);
  static const Color statusConfirmed = Color(0xFFFFC857);
  static const Color statusShipped = Color(0xFF3F8CFF);
  static const Color statusOutForDelivery = Color(0xFFFF8C42);
  static const Color statusDelivered = Color(0xFF00D9A6);
  static const Color statusCancelled = Color(0xFFFF5C5C);

  /// Returns the color associated with a given [OrderStatus].
  static Color colorForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return statusPlaced;
      case OrderStatus.confirmed:
        return statusConfirmed;
      case OrderStatus.shipped:
        return statusShipped;
      case OrderStatus.outForDelivery:
        return statusOutForDelivery;
      case OrderStatus.delivered:
        return statusDelivered;
      case OrderStatus.cancelled:
        return statusCancelled;
    }
  }

  /// Returns the icon associated with a given [OrderStatus].
  static IconData iconForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.receipt_long_rounded;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.shipped:
        return Icons.local_shipping_rounded;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining_rounded;
      case OrderStatus.delivered:
        return Icons.inventory_2_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }
}

/// Gradient used across the app.
class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBar = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient shimmer = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF2A2A45), Color(0xFF1A1A2E)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}

/// API and asset constants.
class AppConstants {
  AppConstants._();

  /// Mock API URL – replace with your GitHub Gist raw URL after uploading.
  static const String mockApiUrl =
      'https://gist.githubusercontent.com/shreyasingh100/a8812f13b5fd13a6428f996915d98982/raw/16d9c95850d6ef27bd562d2d850446f4d56da54f/mock_orders.json';

  /// Local asset path as fallback.
  static const String localAssetPath = 'assets/mock_orders.json';
}
