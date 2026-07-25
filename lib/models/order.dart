/// Order status enum representing all possible order states.
enum OrderStatus {
  placed,
  confirmed,
  shipped,
  outForDelivery,
  delivered,
  cancelled;

  /// Creates an [OrderStatus] from a JSON string value.
  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'placed':
        return OrderStatus.placed;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.placed;
    }
  }

  /// Returns the JSON string representation.
  String toJsonString() {
    switch (this) {
      case OrderStatus.placed:
        return 'placed';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  /// Returns a human-readable display label.
  String get displayLabel {
    switch (this) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Returns the index in the standard order flow (0-4).
  /// Cancelled returns -1 since it's outside the normal flow.
  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

/// Model representing a customer order.
class Order {
  final String id;
  final String customer;
  final List<String> items;
  final double amount;
  final OrderStatus status;
  final DateTime placedAt;

  const Order({
    required this.id,
    required this.customer,
    required this.items,
    required this.amount,
    required this.status,
    required this.placedAt,
  });

  /// Creates an [Order] from a JSON map.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customer: json['customer'] as String,
      items: List<String>.from(json['items'] as List),
      amount: (json['amount'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String),
      placedAt: DateTime.parse(json['placed_at'] as String),
    );
  }

  /// Converts this order to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer,
      'items': items,
      'amount': amount,
      'status': status.toJsonString(),
      'placed_at': placedAt.toIso8601String(),
    };
  }
}
