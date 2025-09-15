# Mini E-commerce Flutter App

A comprehensive Flutter e-commerce application built with Firebase backend, featuring user authentication, product catalog, shopping cart, order management, payment processing, and location services.

## 🚀 Features

### Core E-commerce Features

- **User Authentication**: Email/password and Google Sign-In
- **Product Catalog**: Browse products with search and filtering
- **Shopping Cart**: Add/remove items with quantity management
- **Order Management**: Track order status and history
- **Payment Processing**: Stripe integration for secure payments
- **Product Reviews & Ratings**: Rate and review products after order completion
- **Profile Management**: User profile with photo upload and cropping

### Additional Features

- **Location Services**: Google Maps integration with current location
- **Push Notifications**: Firebase messaging for order updates
- **Image Handling**: Profile photo with crop functionality
- **Responsive Design**: Material Design 3 with modern UI/UX
- **State Management**: Provider pattern for efficient state handling
- **Feature Toggle System**: Easy enable/disable of optional features

### Configuration System

The app includes a simple configuration system in `lib/config/app_config.dart` that allows you to easily enable/disable features:

```dart
class AppConfig {
  static const bool enableGoogleMaps = false; // Set to true when Maps API key is configured
  static const bool enableFirebaseStorage = false; // Set to true when Storage is enabled
  static const bool enableImageCropper = true; // Set to true when image cropping is needed
}
```

**To enable features:**

1. Set the corresponding flag to `true` in `app_config.dart`
2. Configure the required services (Maps API, Firebase Storage, etc.)
3. The app will automatically use the enabled features

**Current Status:**

- ✅ **Core E-commerce**: Fully functional
- ⚠️ **Google Maps**: Disabled (requires API key)
- ⚠️ **Image Upload**: Disabled (requires Firebase Storage)
- ⚠️ **Image Cropping**: Disabled (can be enabled independently)

## 📱 Screenshots

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.34.23.png" width="200" alt="Login Screen">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.34.27.png" width="200" alt="Signup Screen">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.34.51.png" width="200" alt="Home Screen">
</div>

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.34.56.png" width="200" alt="Products List">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.00.png" width="200" alt="Product Details">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.05.png" width="200" alt="Shopping Cart">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.08.png" width="200" alt="Checkout Process">
</div>

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.12.png" width="200" alt="Order History">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.16.png" width="200" alt="Order Details">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.22.png" width="200" alt="User Profile">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.26.png" width="200" alt="Edit Profile">
</div>

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.33.png" width="200" alt="Location Services">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.38.png" width="200" alt="Maps Integration">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.49.png" width="200" alt="Image Picker">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.52.png" width="200" alt="Image Cropping">
</div>

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.35.57.png" width="200" alt="English Interface">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.36.05.png" width="200" alt="Arabic Interface">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.36.09.png" width="200" alt="Language Selection">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.36.13.png" width="200" alt="RTL Layout">
</div>

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.36.19.png" width="200" alt="Rating System">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.36.22.png" width="200" alt="Review Interface">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.37.41.png" width="200" alt="Review Submission">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.46.11.png" width="200" alt="Review History">
</div>

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 15.46.18.png" width="200" alt="Additional Features">
</div>

## 🎥 Demo Video Download

[Download Video](https://github.com/farhazalam/mini-ecommerce/raw/refs/heads/main/videos/Simulator%20Screen%20Recording%20-%20iPhone%2016%20Pro%20-%202025-09-15%20at%2015.58.11.mp4)

## 🏗️ Architecture

### Project Structure

```
lib/
├── models/           # Data models (User, Product, Cart, Order)
├── pages/            # UI screens and pages
├── providers/        # State management (Auth, Cart, Orders)
├── services/         # Business logic and API calls
└── main.dart         # App entry point
```

### Design Patterns

- **Provider Pattern**: For state management across the app
- **Repository Pattern**: Service layer for data operations
- **Model-View-Provider (MVP)**: Clean separation of concerns
- **Factory Pattern**: For creating model instances from Firestore data

### Key Components

- **Firebase Backend**: Authentication, Firestore database, Storage, Messaging
- **Stripe Payment**: Secure payment processing
- **Google Services**: Maps, Sign-In, Location services
- **Image Processing**: Picker, cropper, and storage management

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code

### 1. Clone the Repository

```bash
git clone <repository-url>
cd mini_ecommerce
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Localization Files

```bash
flutter gen-l10n
```

**Note**: The localization feature is implemented only on the homepage for demonstration purposes. It supports English and Arabic languages with RTL layout support.

### 4. Google Maps Setup (Optional)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android and iOS
3. Create API key
4. Add the API key to platform-specific files:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/AppDelegate.swift`

## 🚀 Running the App

### Development Mode

```bash
flutter run
```

### Release Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📱 App Flow

1. **Splash Screen**: App initialization and authentication check
2. **Authentication**: Login/Signup with email or Google
3. **Home Screen**: Quick actions and user welcome
4. **Products**: Browse and search products
5. **Product Details**: View product information and add to cart
6. **Cart**: Manage cart items and proceed to checkout
7. **Checkout**: Payment processing with Stripe
8. **Orders**: Track order status and history
9. **Reviews**: Rate and review products after order completion
10. **Profile**: Manage user profile and settings
11. **Maps**: View current location and nearby services

## 🔧 Key Dependencies

- **firebase_core**: Firebase initialization
- **firebase_auth**: User authentication
- **cloud_firestore**: NoSQL database
- **firebase_storage**: File storage
- **flutter_stripe**: Payment processing
- **google_maps_flutter**: Maps integration
- **image_picker**: Image selection
- **image_cropper**: Image editing
- **provider**: State management
- **cached_network_image**: Image caching

## 🧪 Testing

### Note for Interviewers

This app was built for demonstration purposes and includes test API keys for Stripe and Google services. In a production environment, these keys should be:

- Stored securely using environment variables
- Rotated regularly
- Protected with proper API restrictions
- Monitored for usage and security

### Test Credentials

- Use any valid email/password for testing
- Google Sign-In will work with any Google account
- Stripe test mode is enabled for safe testing

## 🤝 Contributing

This is a demo project. For production use, consider:

- Adding comprehensive error handling
- Implementing proper logging
- Adding unit and integration tests
- Setting up CI/CD pipeline
- Implementing proper security measures
- Adding analytics and monitoring
