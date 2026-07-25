import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../widgets/order_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/offline_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'order_detail_screen.dart';

/// Screen 1 – Orders List
///
/// Displays a list of orders fetched from the mock API.
/// Features:
/// - Pull-to-refresh
/// - Colored status chips on each order card
/// - Loading, empty, and error states
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient App Bar ──
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.scaffoldBg,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'My Orders',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1A1040),
                      AppColors.scaffoldBg,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 20),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.gradientStart.withValues(alpha: 0.2),
                            AppColors.gradientStart.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.sort_rounded,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    // Could add sorting in the future
                  },
                ),
              ),
            ],
          ),

          // ── Offline Banner ──
          SliverToBoxAdapter(
            child: Consumer<OrderProvider>(
              builder: (context, provider, _) {
                if (provider.isOffline && provider.state != OrderListState.offline) {
                  return Container(
                    color: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'You are currently offline. Viewing cached data.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // ── Body content ──
          SliverFillRemaining(
            child: Consumer<OrderProvider>(
              builder: (context, provider, _) {
                switch (provider.state) {
                  case OrderListState.loading:
                    return const LoadingWidget();

                  case OrderListState.empty:
                    return const EmptyWidget();

                  case OrderListState.error:
                    return OrderErrorWidget(
                      message: provider.errorMessage,
                      onRetry: () => provider.loadOrders(),
                    );
                    
                  case OrderListState.offline:
                    return const OfflineWidget();

                  case OrderListState.loaded:
                    return RefreshIndicator(
                      onRefresh: () => provider.refreshOrders(),
                      color: AppColors.gradientStart,
                      backgroundColor: AppColors.cardBg,
                      displacement: 20,
                      child: AnimationLimiter(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 24,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: provider.orders.length,
                          itemBuilder: (context, index) {
                            final order = provider.orders[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: OrderCard(
                                    order: order,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (context, animation, secondaryAnimation) =>
                                                  OrderDetailScreen(order: order),
                                          transitionsBuilder: (context, animation,
                                              secondaryAnimation, child) {
                                            return FadeTransition(
                                              opacity: CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeOut,
                                              ),
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0.05, 0),
                                                  end: Offset.zero,
                                                ).animate(CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOut,
                                                )),
                                                child: child,
                                              ),
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 350),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
