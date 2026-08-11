import 'package:firebase_messaging/firebase_messaging.dart';

import '../../auth/data/profile_repository.dart';

/// Registers the device FCM token so the server can push notifications
/// (Module 13). Called once the user is signed in.
class FcmService {
  FcmService(this._profile);

  final ProfileRepository _profile;

  Future<void> registerToken() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    final token = await messaging.getToken();
    if (token != null) {
      await _profile.setFcmToken(token);
    }
    // Persist rotated tokens too.
    messaging.onTokenRefresh.listen(_profile.setFcmToken);
  }

  /// Deep-links (NOTIF-02): when a notification carrying a `route` is tapped —
  /// either from the background or a cold start — hand the route to [onOpen].
  Future<void> setupTapHandling(void Function(String route) onOpen) async {
    void handle(RemoteMessage? message) {
      final route = message?.data['route'];
      if (route is String && route.isNotEmpty) onOpen(route);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handle);
    handle(await FirebaseMessaging.instance.getInitialMessage());
  }
}
