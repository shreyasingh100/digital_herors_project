import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../utils/constants.dart';

/// Service responsible for fetching order data from the mock API
/// with a local asset fallback.
class OrderService {
  /// Fetches orders from the remote mock API.
  /// Falls back to the local JSON asset if the network request fails.
  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstants.mockApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parseOrders(response.body);
      } else {
        // Non-200 status → fall back to local
        return _fetchLocalOrders();
      }
    } catch (_) {
      // Network error, timeout, etc. → fall back to local
      return _fetchLocalOrders();
    }
  }

  /// Fetches orders from the bundled local JSON asset.
  Future<List<Order>> _fetchLocalOrders() async {
    try {
      final jsonString =
          await rootBundle.loadString(AppConstants.localAssetPath);
      return _parseOrders(jsonString);
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Parses a JSON string into a list of [Order] objects.
  List<Order> _parseOrders(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => Order.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
