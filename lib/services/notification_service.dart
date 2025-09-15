import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission for notifications
    await _requestPermission();

    // Configure message handlers
    _configureMessageHandlers();

    // Save FCM token to user document
    await _saveFCMToken();
  }

  static Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Permission status handled silently
  }

  static void _configureMessageHandlers() {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  static Future<void> _saveFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'fcmToken': token});
        }
      }
    } catch (e) {
      // Error saving FCM token - handled silently
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // For foreground messages, Firebase Messaging will automatically show
    // the notification on Android. On iOS, you might want to show a custom
    // in-app notification or let the system handle it.
  }

  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    // Handle navigation to orders page or specific order
    final orderId = message.data['orderId'];
    if (orderId != null) {
      // Navigate to order details
      // This would be handled by your navigation logic
    }
  }

  static Future<void> sendOrderNotification({
    required String userId,
    required String orderId,
    required String orderStatus,
  }) async {
    try {
      // Get user's FCM token
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken == null) {
        return;
      }

      // In a real app, you would send this via your backend using Firebase Admin SDK
      // or Firebase Cloud Functions. For now, we'll just log the notification details.

      // Example of what your backend would send:
      // {
      //   "to": fcmToken,
      //   "notification": {
      //     "title": "Order Update",
      //     "body": "Your order #$orderId status: $orderStatus"
      //   },
      //   "data": {
      //     "orderId": orderId,
      //     "orderStatus": orderStatus
      //   }
      // }
    } catch (e) {
      // Error sending notification - handled silently
    }
  }

  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

// Background message handler (must be top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message silently
}
