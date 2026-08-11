import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/notification_prefs.dart';

/// Reads/writes the signed-in user's notification preferences
/// (User.notificationPrefs JSON) via Data Connect.
class NotificationPrefsRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  Future<NotificationPrefs> get() async {
    final result = await _connector.getMyNotificationPrefs().execute();
    final users = result.data.users;
    final raw = users.isNotEmpty ? users.first.notificationPrefs?.value : null;
    return NotificationPrefs.fromMap(raw is Map ? raw : null);
  }

  Future<void> save(NotificationPrefs prefs) async {
    await _connector.setNotificationPrefs(prefs: prefs.toMap()).execute();
  }
}
