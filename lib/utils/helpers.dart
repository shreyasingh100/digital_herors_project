import 'package:intl/intl.dart';

/// Formats a [DateTime] into a human-readable string.
/// Example: "20 Jul 2025, 4:15 PM"
String formatDate(DateTime date) {
  return DateFormat('d MMM yyyy, h:mm a').format(date.toLocal());
}

/// Formats a [DateTime] into a short date string.
/// Example: "20 Jul"
String formatDateShort(DateTime date) {
  return DateFormat('d MMM').format(date.toLocal());
}

/// Formats a [double] amount as Indian Rupees.
/// Example: "₹2,499.00"
String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

/// Returns a relative time string like "2 days ago" or "Just now".
String timeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
  } else {
    return 'Just now';
  }
}
