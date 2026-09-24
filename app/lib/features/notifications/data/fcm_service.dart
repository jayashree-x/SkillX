import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../auth/data/profile_repository.dart';

/// Registers the device FCM token and displays notifications (Module 13).
///
/// Android only shows a `notification`-payload message in the system tray when
/// the app is backgrounded or killed. While the app is in the **foreground**,
/// the message arrives via [FirebaseMessaging.onMessage] but nothing renders
/// it — so we surface it ourselves with flutter_local_notifications on a
/// dedicated channel. Taps (foreground local notifications and background FCM
/// ones alike) deep-link via the `route` in the data payload (NOTIF-02).
class FcmService {
  FcmService(this._profile);

  final ProfileRepository _profile;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  void Function(String route)? _onOpen;

  // Must match the manifest's default_notification_channel_id so background
  // notifications land on the same channel as the foreground ones.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'skillx_default',
    'Notifications',
    description: 'Requests, sessions, quizzes and rewards.',
    importance: Importance.high,
  );

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

  /// Deep-links (NOTIF-02): route notification taps to [onOpen], and set up the
  /// foreground display so notifications aren't silently dropped while the app
  /// is open. Call once after sign-in.
  Future<void> setupTapHandling(void Function(String route) onOpen) async {
    _onOpen = onOpen;
    await _initForegroundDisplay();

    // Background / cold-start taps on FCM system notifications.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpened);
    _handleOpened(await FirebaseMessaging.instance.getInitialMessage());
  }

  Future<void> _initForegroundDisplay() async {
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _local.initialize(
      settings: init,
      // Taps on the local notification we show while foregrounded.
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null && route.isNotEmpty) _onOpen?.call(route);
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen(_showForeground);
  }

  void _showForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return; // data-only messages need no banner
    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['route'] as String?,
    );
  }

  void _handleOpened(RemoteMessage? message) {
    final route = message?.data['route'];
    if (route is String && route.isNotEmpty) _onOpen?.call(route);
  }
}
