# Online Book Store - Complete Flutter Android App & Laravel REST API Backend

A production-style, modern e-commerce mobile application and web ecosystem built with **Flutter (Material 3)**, **Laravel (PHP MVC)**, and **MySQL**.

---

## 🏛️ System Architecture

```
┌─────────────────────────────────────────────────────────┐
│            Flutter Android Mobile Application           │
│        (Provider, Material 3, Clean Architecture)       │
└────────────────────────────┬────────────────────────────┘
                             │  REST API (JSON / Bearer Token)
                             ▼
┌─────────────────────────────────────────────────────────┐
│                 Laravel REST API Backend                │
│       (Sanctum Token Auth, Controllers, Eloquent)       │
└────────────────────────────┬────────────────────────────┘
                             │
            ┌────────────────┴────────────────┐
            ▼                                 ▼
┌─────────────────────────┐       ┌───────────────────────┐
│     MySQL Database      │       │  Blade Web Application│
│ (Users, Books, Orders)  │       │   (Admin & Customers) │
└─────────────────────────┘       └───────────────────────┘
```

---

## 📁 Project Directory Structure

```
online_book_store/
│
├── flutter_app/                     # Flutter Android Application
│   ├── android/                     # Android Native Configuration (INTERNET, Cleartext)
│   ├── lib/
│   │   ├── main.dart                # App Entry Point & MultiProvider Wiring
│   │   ├── config/
│   │   │   ├── api_config.dart      # Centralized API Endpoints & Image Resolver
│   │   │   ├── app_colors.dart      # Modern Palette (Royal Blue, Amber Gold, Slate)
│   │   │   └── app_theme.dart       # Material 3 Theme (Typography, Cards, Buttons)
│   │   ├── models/                  # Null-safe Models (fromJson / toJson)
│   │   │   ├── user.dart
│   │   │   ├── book.dart
│   │   │   ├── category.dart
│   │   │   ├── cart.dart
│   │   │   ├── cart_item.dart
│   │   │   ├── wishlist.dart
│   │   │   ├── order.dart
│   │   │   ├── order_item.dart
│   │   │   ├── review.dart
│   │   │   └── api_response.dart
│   │   ├── services/                # Network & API Integration
│   │   │   ├── api_service.dart     # HTTP Client, Error Handling, Bearer Tokens
│   │   │   ├── auth_service.dart
│   │   │   ├── book_service.dart
│   │   │   ├── cart_service.dart
│   │   │   ├── wishlist_service.dart
│   │   │   ├── order_service.dart
│   │   │   └── review_service.dart
│   │   ├── providers/               # Reactive State Management
│   │   │   ├── auth_provider.dart
│   │   │   ├── book_provider.dart
│   │   │   ├── cart_provider.dart
│   │   │   ├── wishlist_provider.dart
│   │   │   └── order_provider.dart
│   │   ├── screens/                 # Mobile Application Screens
│   │   │   ├── splash/splash_screen.dart
│   │   │   ├── auth/login_screen.dart
│   │   │   ├── auth/register_screen.dart
│   │   │   ├── auth/forgot_password_screen.dart
│   │   │   ├── main_nav_screen.dart
│   │   │   ├── home/home_screen.dart
│   │   │   ├── books/books_screen.dart
│   │   │   ├── books/book_details_screen.dart
│   │   │   ├── books/search_screen.dart
│   │   │   ├── categories/categories_screen.dart
│   │   │   ├── cart/cart_screen.dart
│   │   │   ├── wishlist/wishlist_screen.dart
│   │   │   ├── checkout/checkout_screen.dart
│   │   │   ├── orders/order_success_screen.dart
│   │   │   ├── orders/orders_screen.dart
│   │   │   ├── orders/order_details_screen.dart
│   │   │   ├── reviews/review_screen.dart
│   │   │   ├── profile/profile_screen.dart
│   │   │   └── profile/edit_profile_screen.dart
│   │   ├── widgets/                 # Reusable UI Components
│   │   │   ├── book_card.dart
│   │   │   ├── category_card.dart
│   │   │   ├── search_bar.dart
│   │   │   ├── rating_widget.dart
│   │   │   ├── price_widget.dart
│   │   │   ├── order_status_widget.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── empty_state_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── custom_button.dart
│   │   │   └── custom_text_field.dart
│   │   └── utils/
│   │       ├── constants.dart
│   │       ├── validators.dart
│   │       └── helpers.dart
│   ├── test/
│   │   ├── unit_test.dart           # Models, Validators, and Helpers tests
│   │   └── widget_test.dart         # UI Widget Component tests
│   └── pubspec.yaml
│
└── laravel_backend/                 # Laravel REST API & Web Backend
    ├── app/
    │   ├── Http/Controllers/Api/   # API Controllers (Auth, Book, Cart, Order, etc.)
    │   └── Models/                  # Eloquent Models (User, Book, Category, etc.)
    ├── database/
    │   ├── migrations/              # Database Table Schemas
    │   └── seeders/DatabaseSeeder.php # Sample Books, Categories, and Reviews
    ├── resources/views/             # Blade Views (Web Store & Admin Dashboard)
    ├── routes/
    │   ├── api.php                  # REST API Route Declarations
    │   └── web.php                  # Web Store & Admin Routes
    └── composer.json
```

---

## 🚀 Quick Start Guide

### 1. Backend Setup (Laravel & MySQL)

1. Open MySQL (e.g. via XAMPP Control Panel) and create the database:
   ```sql
   CREATE DATABASE online_book_store;
   ```
2. Navigate to the backend directory and configure `.env`:
   ```bash
   cd laravel_backend
   copy .env.example .env
   ```
3. Run database migrations and seed realistic bookstore catalog data:
   ```bash
   php artisan key:generate
   php artisan migrate --seed
   php artisan storage:link
   ```
4. Start the Laravel development server (accessible to network devices):
   ```bash
   php artisan serve --host=0.0.0.0 --port=8000
   ```

#### 🔑 Pre-seeded Test Accounts
- **Customer**: `user@example.com` / `password`
- **Administrator**: `admin@example.com` / `password`

---

### 2. Mobile App Setup (Flutter Android)

1. Navigate to the Flutter app directory:
   ```bash
   cd flutter_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure your API IP Address in `lib/config/api_config.dart`:
   - **Android Emulator**: Uses `http://10.0.2.2:8000/api` (Default).
   - **Physical Android Device**: Change `baseUrl` to your computer's local Wi-Fi IP (e.g. `http://192.168.1.100:8000/api`).
4. Run the Flutter application:
   ```bash
   flutter run
   ```

---

## 📱 Building Android APKs

### Debug APK (For rapid testing)
```bash
flutter build apk --debug
```
*Generated file: `build/app/outputs/flutter-apk/app-debug.apk`*

### Release APK (For production deployment)
```bash
flutter build apk --release
```
*Generated file: `build/app/outputs/flutter-apk/app-release.apk`*

---

## 🧪 Testing

Execute automated unit tests and widget component tests:
```bash
cd flutter_app
flutter test
```

Perform static analysis:
```bash
flutter analyze
```

---

## 📚 REST API Documentation

| Endpoint | Method | Description | Auth Required |
| :--- | :--- | :--- | :--- |
| `/api/register` | `POST` | Create a new customer account | No |
| `/api/login` | `POST` | Authenticate and retrieve Bearer token | No |
| `/api/logout` | `POST` | Invalidate current Bearer token | Yes |
| `/api/profile` | `GET` | Get current user's profile | Yes |
| `/api/profile` | `PUT` | Update name, phone, address | Yes |
| `/api/change-password` | `POST` | Change current password | Yes |
| `/api/books` | `GET` | Catalog with search, category & price filters | No |
| `/api/books/popular` | `GET` | Top-rated popular books | No |
| `/api/books/latest` | `GET` | Recently added books | No |
| `/api/books/recommended` | `GET` | Curated recommended books | No |
| `/api/books/{id}` | `GET` | Full book details & customer reviews | No |
| `/api/categories` | `GET` | All categories with book counts | No |
| `/api/cart` | `GET` | Retrieve customer's active cart | Yes |
| `/api/cart` | `POST` | Add book to cart with quantity | Yes |
| `/api/cart/{id}` | `PUT` | Update cart item quantity | Yes |
| `/api/cart/{id}` | `DELETE` | Remove item from cart | Yes |
| `/api/cart/clear` | `POST` | Empty entire cart | Yes |
| `/api/wishlist` | `GET` | List customer's saved books | Yes |
| `/api/wishlist` | `POST` | Add book to wishlist | Yes |
| `/api/wishlist/{id}` | `DELETE` | Remove book from wishlist | Yes |
| `/api/orders` | `GET` | View past order history | Yes |
| `/api/orders` | `POST` | Place order (totals calculated securely on backend) | Yes |
| `/api/orders/{id}` | `GET` | Order details with tracking timeline | Yes |
| `/api/orders/{id}/cancel`| `POST` | Cancel pending order & restore stock | Yes |
| `/api/reviews` | `POST` | Post 1-5 star review and comment | Yes |
| `/api/books/{id}/reviews`| `GET` | Get reviews for a specific book | No |

---

## 🔒 Security & Best Practices

1. **Token Authentication**: Secure Bearer tokens managed via Laravel Sanctum; never stores plaintext passwords locally.
2. **Backend Price Integrity**: All order totals, discounts, shipping fees, and taxes are calculated directly on the Laravel backend from database records.
3. **Inventory Management**: Concurrency-safe stock locking (`lockForUpdate`) ensures customers cannot purchase more items than available in stock.
4. **Android Cleartext Configuration**: `android:usesCleartextTraffic="true"` configured in `AndroidManifest.xml` enables seamless development over local LAN IP addresses.
