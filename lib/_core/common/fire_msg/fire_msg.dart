import 'package:e_com/main.export.dart';

/// FireMessage class - Firebase messaging is disabled
/// Set FireMessage.isFireActive = true and add firebase_messaging package to enable
class FireMessage {
  FireMessage._();

  static bool isFireActive = false;

  static FireMessage? get instance => isFireActive ? FireMessage._() : null;

  static Future<void> initiate() async {
    if (!isFireActive) return;
    Logger('Firebase messaging is disabled', 'FireMessage');
  }

  static Future<void> initiateWithFirebase() async {
    if (!isFireActive) {
      Logger('Firebase is not active', 'FireMessage');
      return;
    }
    // Firebase initialization would happen here when enabled
    Logger('Firebase is disabled - skipping initialization', 'FireMessage');
  }

  void onEvents({
    Function(Map<String, dynamic> msg)? onMessage,
    Function(Map<String, dynamic> msg)? onMessageOpenedApp,
  }) {
    // No-op when Firebase is disabled
  }

  Future<void> onInitialMessage(
      Function(Map<String, dynamic> msg)? onMessage) async {
    // No-op when Firebase is disabled
  }

  Future<void> updateServerToken(bool isLoggedIn) async {
    // No-op when Firebase is disabled
  }
}
