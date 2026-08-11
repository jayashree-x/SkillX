/// The signed-in user's header data on Home (HOME-01).
class HomeUser {
  const HomeUser({
    required this.name,
    required this.currentStreak,
    this.photoUrl,
  });

  final String name;
  final int currentStreak;
  final String? photoUrl;

  /// First name for the greeting; falls back to the whole name.
  String get firstName => name.split(' ').first;
}
