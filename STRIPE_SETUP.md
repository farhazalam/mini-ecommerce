# Stripe Payment Setup Guide

## Current Status

✅ **Fixed**: The Apple Pay merchant identifier error has been resolved by disabling Apple Pay configuration until proper setup is complete.

## What Was Fixed

1. **Apple Pay Configuration**: Removed the Apple Pay configuration that was causing the `merchantIdentifier` error
2. **Error Handling**: Improved error handling throughout the payment flow
3. **Payment Validation**: Added validation for payment intents before processing
4. **Better UX**: Enhanced error messages and retry functionality

## Current Payment Methods

- ✅ Credit/Debit Cards (via Stripe Payment Sheet)
- ✅ Google Pay (Android)
- ❌ Apple Pay (disabled until merchant identifier is configured)

## How to Enable Apple Pay (Future)

### 1. Get Apple Pay Merchant Identifier

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to Certificates, Identifiers & Profiles
3. Create a new Merchant ID
4. Note down the merchant identifier (format: `merchant.com.yourcompany.appname`)

### 2. Configure Stripe Dashboard

1. Go to your [Stripe Dashboard](https://dashboard.stripe.com/)
2. Navigate to Settings > Payment methods
3. Enable Apple Pay
4. Add your merchant identifier

### 3. Update Code

In `lib/services/payment_service.dart`, update the `getApplePayConfig()` method:

```dart
static PaymentSheetApplePay? getApplePayConfig() {
  return const PaymentSheetApplePay(
    merchantCountryCode: 'AE',
    merchantIdentifier: 'merchant.com.yourcompany.miniecommerce', // Your actual merchant ID
  );
}
```

### 4. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>com.apple.developer.in-app-payments</key>
<array>
    <string>merchant.com.yourcompany.miniecommerce</string>
</array>
```

## Testing

- Use Stripe test cards: https://stripe.com/docs/testing
- Test with different currencies and amounts
- Verify error handling works correctly

## Security Notes

- Never commit real API keys to version control
- Use environment variables for production keys
- Implement proper server-side validation for production

## Troubleshooting

- If you see "merchantIdentifier must be specified" error, Apple Pay is still disabled
- Check Stripe dashboard for payment method configuration
- Verify API keys are correct and have proper permissions
