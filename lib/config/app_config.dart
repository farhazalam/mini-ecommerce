class AppConfig {
  // Feature flags - Change these to enable/disable features
  static const bool enableGoogleMaps =
      false; // Set to true when Maps API key is configured
  static const bool enableFirebaseStorage =
      false; // Set to true when Storage is enabled
  static const bool enableImageCropper =
      true; // Set to true when image cropping is needed

  // Placeholder messages
  static const String mapsDisabledMessage =
      'Google Maps is currently disabled.\nPlease configure your Maps API key to enable this feature.';
  static const String storageDisabledMessage =
      'Image upload to Firebase Storage is currently disabled.\nPlease enable Firebase Storage to save your profile photos.';
  static const String cropperDisabledMessage =
      'Image cropping is currently disabled.\nPlease enable this feature in app configuration.';
}
