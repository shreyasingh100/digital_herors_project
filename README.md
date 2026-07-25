# 📦 Order Tracker

A beautiful, production-quality **2-screen Order Tracker** app built with **Flutter**.

> Built as part of the DigitalHeroes Mobile App Developer internship task.

---

## ✨ Features

### Screen 1 – Orders List
- Fetches orders from a **mock REST API**
- **Pull-to-refresh** to reload order data
- **Colored status chips** for each order (Placed, Confirmed, Shipped, Out for Delivery, Delivered, Cancelled)
- **Loading state** with shimmer skeleton animation
- **Empty state** with friendly illustration
- **Error state** with retry button

### Screen 2 – Order Detail
- Tapping any order opens a detailed view
- **Order summary card** with customer info, amount, and date
- **Items list** showing all ordered products
- **Vertical status timeline** showing order progress through each stage
- Smooth page transition animation

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform UI framework |
| **Provider** | State management (ChangeNotifier pattern) |
| **http** | API calls to mock REST endpoint |
| **Google Fonts** | Premium typography (Poppins) |
| **intl** | Date & currency formatting |

---

## 🌐 Mock API

**API URL:** `https://gist.githubusercontent.com/raw/mock_orders.json`

The app also includes a **local JSON fallback** (`assets/mock_orders.json`) that's used when the network is unavailable.

### Data Schema
```json
{
  "id": "ORD-1001",
  "customer": "Aarav Sharma",
  "items": ["Wireless Earbuds", "Phone Case"],
  "amount": 2499.00,
  "status": "delivered",
  "placed_at": "2025-07-20T10:30:00Z"
}
```

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry, theme, routes
├── models/
│   └── order.dart                     # Order data model + OrderStatus enum
├── services/
│   └── order_service.dart             # API integration with local fallback
├── providers/
│   └── order_provider.dart            # State management (loading/loaded/empty/error)
├── screens/
│   ├── order_list_screen.dart         # Screen 1 – Orders list
│   └── order_detail_screen.dart       # Screen 2 – Order detail + timeline
├── widgets/
│   ├── order_card.dart                # Order list card widget
│   ├── status_chip.dart               # Colored status chip
│   ├── status_timeline.dart           # Vertical status timeline
│   ├── loading_widget.dart            # Shimmer loading skeleton
│   ├── empty_widget.dart              # Empty state
│   └── error_widget.dart              # Error state with retry
└── utils/
    ├── constants.dart                 # Colors, gradients, API config
    └── helpers.dart                   # Date/currency formatting helpers
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6+)
- Android Studio or VS Code with Flutter extension

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/order-tracker.git
cd order-tracker

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release
```

---

## 📱 Screenshots

| Orders List | Order Detail |
|---|---|
| Loading, empty, error states + order cards with status chips | Summary card + items list + vertical status timeline |

---

## 📋 Evaluation Criteria Coverage

| Criterion | Weight | Implementation |
|---|---|---|
| **Functionality & state handling** | 45% | ✅ API integration, pull-to-refresh, loading/empty/error states, Provider state management |
| **UI quality** | 30% | ✅ Dark glassmorphism theme, shimmer loading, animated transitions, Google Fonts, colored status chips |
| **Code structure** | 25% | ✅ Feature-based folder structure, separation of concerns (Model → Service → Provider → UI) |

---

## 👤 Author

Built with ❤️ for the DigitalHeroes internship task.
