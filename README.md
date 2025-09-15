# Mini E-commerce Flutter App

A comprehensive Flutter e-commerce application built with Firebase backend, featuring user authentication, product catalog, shopping cart, order management, payment processing, and location services.

## 🚀 Features

### Core E-commerce Features

- **User Authentication**: Email/password and Google Sign-In
- **Product Catalog**: Browse products with search and filtering
- **Shopping Cart**: Add/remove items with quantity management
- **Order Management**: Track order status and history
- **Payment Processing**: Stripe integration for secure payments
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

### 3. Google Maps Setup (Optional)

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
9. **Profile**: Manage user profile and settings
10. **Maps**: View current location and nearby services

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
