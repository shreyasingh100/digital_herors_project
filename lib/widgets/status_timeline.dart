import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/constants.dart';

/// A step in the status timeline.
class _TimelineStep {
  final OrderStatus status;
  final IconData icon;
  final String title;
  final String subtitle;

  const _TimelineStep({
    required this.status,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

/// A vertical status timeline that visually shows the order's progress
/// through each stage: Placed → Confirmed → Shipped → Out for Delivery → Delivered.
///
/// For cancelled orders, a special single-step cancelled timeline is shown.
class StatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const StatusTimeline({super.key, required this.currentStatus});

  /// The standard order flow steps.
  static const List<_TimelineStep> _steps = [
    _TimelineStep(
      status: OrderStatus.placed,
      icon: Icons.receipt_long_rounded,
      title: 'Order Placed',
      subtitle: 'Your order has been placed successfully',
    ),
    _TimelineStep(
      status: OrderStatus.confirmed,
      icon: Icons.check_circle_outline_rounded,
      title: 'Order Confirmed',
      subtitle: 'Seller has confirmed your order',
    ),
    _TimelineStep(
      status: OrderStatus.shipped,
      icon: Icons.local_shipping_rounded,
      title: 'Shipped',
      subtitle: 'Your order is on its way to the hub',
    ),
    _TimelineStep(
      status: OrderStatus.outForDelivery,
      icon: Icons.delivery_dining_rounded,
      title: 'Out for Delivery',
      subtitle: 'Order is out for delivery to your address',
    ),
    _TimelineStep(
      status: OrderStatus.delivered,
      icon: Icons.inventory_2_rounded,
      title: 'Delivered',
      subtitle: 'Your order has been delivered',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Cancelled orders get a special timeline
    if (currentStatus == OrderStatus.cancelled) {
      return _buildCancelledTimeline();
    }

    final currentIndex = currentStatus.stepIndex;

    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == _steps.length - 1;

        return _buildTimelineItem(
          step: step,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isLast: isLast,
        );
      }),
    );
  }

  Widget _buildCancelledTimeline() {
    return Column(
      children: [
        // Show "Placed" as completed
        _buildTimelineItem(
          step: _steps[0],
          isCompleted: true,
          isCurrent: false,
          isLast: false,
        ),
        // Show "Cancelled" as the current/final step
        _buildTimelineItem(
          step: const _TimelineStep(
            status: OrderStatus.cancelled,
            icon: Icons.cancel_rounded,
            title: 'Order Cancelled',
            subtitle: 'This order has been cancelled',
          ),
          isCompleted: true,
          isCurrent: true,
          isLast: true,
          overrideColor: AppColors.statusCancelled,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required _TimelineStep step,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
    Color? overrideColor,
  }) {
    final color = overrideColor ?? AppColors.colorForStatus(step.status);
    final activeColor = isCompleted ? color : AppColors.textMuted.withValues(alpha: 0.3);
    final textColor =
        isCompleted ? AppColors.textPrimary : AppColors.textMuted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: Icon + Connector Line ──
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Icon circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: isCurrent ? 44 : 36,
                  height: isCurrent ? 44 : 36,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? activeColor.withValues(alpha: 0.15)
                        : AppColors.cardBgLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: activeColor,
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    step.icon,
                    color: activeColor,
                    size: isCurrent ? 20 : 16,
                  ),
                ),
                // Connector line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? activeColor.withValues(alpha: 0.5)
                            : AppColors.textMuted.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ── Right: Text content ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: isCurrent ? 6 : 2,
                bottom: isLast ? 0 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: isCurrent ? 16 : 14,
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.subtitle,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.textSecondary
                          : AppColors.textMuted.withValues(alpha: 0.5),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Current Status',
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
