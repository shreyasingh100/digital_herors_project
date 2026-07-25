import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Shimmer loading placeholder widget that displays skeleton cards
/// while orders are being fetched.
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildShimmerCard(index);
          },
        );
      },
    );
  }

  Widget _buildShimmerCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.04),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(80, 14),
                    _shimmerBox(70, 22, borderRadius: 20),
                  ],
                ),
                const SizedBox(height: 16),
                // Middle row shimmer
                Row(
                  children: [
                    _shimmerBox(36, 36, borderRadius: 10),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(120, 14),
                        const SizedBox(height: 6),
                        _shimmerBox(60, 10),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Bottom row shimmer
                _shimmerBox(double.infinity, 36, borderRadius: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _shimmerBox(double width, double height,
      {double borderRadius = 6}) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: const [
            AppColors.cardBgLight,
            Color(0xFF2E2E50),
            AppColors.cardBgLight,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment(_animation.value - 1, 0),
          end: Alignment(_animation.value, 0),
        ),
      ),
    );
  }
}
