import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/order_service.dart';

/// Possible states for the orders list.
enum OrderListState { loading, loaded, empty, error, offline }

/// Provider that manages the state of the orders list.
class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  OrderProvider({OrderService? orderService})
      : _orderService = orderService ?? OrderService() {
    _initConnectivity();
  }

  void _initConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final isDisconnected = results.every((result) => result == ConnectivityResult.none);
      if (isDisconnected) {
        _isOffline = true;
        if (_orders.isEmpty) {
          _state = OrderListState.offline;
        }
        notifyListeners();
      } else {
        final wasOffline = _isOffline;
        _isOffline = false;
        if (wasOffline && (_state == OrderListState.offline || _state == OrderListState.error)) {
          loadOrders();
        } else if (wasOffline) {
          notifyListeners(); // Update banner UI
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // ── State ──────────────────────────────────────────────────────────────

  OrderListState _state = OrderListState.loading;
  OrderListState get state => _state;

  List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  // ── Actions ────────────────────────────────────────────────────────────

  /// Loads orders from the service. Called on initial load.
  Future<void> loadOrders() async {
    // Check initial connectivity before loading
    final results = await Connectivity().checkConnectivity();
    if (results.every((result) => result == ConnectivityResult.none)) {
      _isOffline = true;
      _state = OrderListState.offline;
      notifyListeners();
      return;
    }

    _state = OrderListState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final fetchedOrders = await _orderService.fetchOrders();

      if (fetchedOrders.isEmpty) {
        _state = OrderListState.empty;
        _orders = [];
      } else {
        _state = OrderListState.loaded;
        _orders = fetchedOrders;
      }
    } catch (e) {
      _state = OrderListState.error;
      _errorMessage = 'Something went wrong. Please try again.';
      _orders = [];
    }

    notifyListeners();
  }

  /// Refreshes orders (used by pull-to-refresh).
  Future<void> refreshOrders() async {
    try {
      final fetchedOrders = await _orderService.fetchOrders();

      if (fetchedOrders.isEmpty) {
        _state = OrderListState.empty;
        _orders = [];
      } else {
        _state = OrderListState.loaded;
        _orders = fetchedOrders;
      }
    } catch (e) {
      // On refresh failure, keep existing data but show a snackbar
      // (handled at the UI level)
      if (_orders.isEmpty) {
        _state = OrderListState.error;
        _errorMessage = 'Unable to refresh. Check your connection.';
      }
    }

    notifyListeners();
  }

  /// Returns an order by its ID, or null if not found.
  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }
}
