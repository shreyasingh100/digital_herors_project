import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/order_provider.dart';
import 'screens/order_list_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for a polished look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.scaffoldBg,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const OrderTrackerApp());
}

/// Root widget of the Order Tracker application.
class OrderTrackerApp extends StatelessWidget {
  const OrderTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderProvider(),
      child: MaterialApp(
        title: 'Order Tracker',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const OrderListScreen(),
      ),
    );
  }

  /// Builds the app-wide dark theme with Google Fonts and custom colors.
  ThemeData _buildTheme() {
    final baseTheme = ThemeData.dark();

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gradientStart,
        secondary: AppColors.gradientEnd,
        surface: AppColors.cardBg,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      splashColor: AppColors.gradientStart.withValues(alpha: 0.08),
      highlightColor: AppColors.gradientStart.withValues(alpha: 0.04),
    );
  }
}
