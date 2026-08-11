/// Shared form validators for the auth screens (REG-02/03, LOG-11).
abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your full name.';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email.';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter a password.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  /// Login password: presence only — do not hint length on the login screen.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password.';
    return null;
  }
}
