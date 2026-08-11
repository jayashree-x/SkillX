import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_prefs_repository.dart';
import '../domain/notification_prefs.dart';

final notificationPrefsRepositoryProvider =
    Provider<NotificationPrefsRepository>((ref) => NotificationPrefsRepository());

final notificationPrefsProvider = FutureProvider<NotificationPrefs>(
  (ref) => ref.watch(notificationPrefsRepositoryProvider).get(),
);
