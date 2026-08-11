import 'package:flutter_test/flutter_test.dart';
import 'package:skillx/features/notifications/domain/notification_prefs.dart';

void main() {
  test('defaults: every category on, quiet hours off', () {
    const p = NotificationPrefs();
    expect(p.requests, isTrue);
    expect(p.sessions, isTrue);
    expect(p.teaching, isTrue);
    expect(p.quietEnabled, isFalse);
  });

  test('toMap / fromMap round-trips', () {
    const p = NotificationPrefs(
      requests: false,
      quizzes: false,
      quietStart: 22,
      quietEnd: 7,
      utcOffsetMinutes: 330,
    );
    final r = NotificationPrefs.fromMap(p.toMap());
    expect(r.requests, isFalse);
    expect(r.quizzes, isFalse);
    expect(r.sessions, isTrue);
    expect(r.quietStart, 22);
    expect(r.quietEnd, 7);
    expect(r.quietEnabled, isTrue);
    expect(r.utcOffsetMinutes, 330);
  });

  test('fromMap(null) yields defaults', () {
    final r = NotificationPrefs.fromMap(null);
    expect(r.rewards, isTrue);
    expect(r.quietEnabled, isFalse);
    expect(r.utcOffsetMinutes, 0);
  });
}
