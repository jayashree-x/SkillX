import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper over Firebase Auth + Google Sign-In. Holds no UI concerns.
///
/// Covers Module 1 (Register) and Module 2 (Login) of the PRD:
/// email/password + Google, email verification, password reset, session
/// persistence (Firebase's default) and logout.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _google = GoogleSignIn.instance;
  bool _googleReady = false;

  /// Fires on sign-in, sign-out, token refresh AND profile/emailVerified
  /// changes — the router listens to this to re-run its redirect.
  Stream<User?> authStateChanges() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  bool get isPasswordUser =>
      _auth.currentUser?.providerData.any((p) => p.providerId == 'password') ??
      false;

  // --------------------------------------------------------------- email/pw

  /// REG-01..04: create the account, set the display name, send the
  /// verification email. Throws [AuthFailure] on known errors (REG-08).
  Future<User> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      await user.updateDisplayName(name.trim());
      await user.sendEmailVerification();
      await user.reload();
      return _auth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    }
  }

  /// LOG-01: sign in. LOG-04: errors are deliberately generic.
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    }
  }

  /// LOG-02/08: send a password-reset email. Never reveals whether the
  /// address is registered — callers show the same confirmation regardless.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      // Swallow "user-not-found" so we don't leak account existence (LOG-09).
      if (e.code == 'user-not-found') return;
      throw AuthFailure.fromCode(e.code);
    }
  }

  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  /// Pulls the latest state so a freshly-verified email is reflected.
  Future<void> reloadUser() => _auth.currentUser?.reload() ?? Future.value();

  // ----------------------------------------------------------------- google

  /// First Google login creates a Firebase user (auto-verified email). The
  /// caller then routes into "Complete your profile" if skills are missing.
  Future<User> signInWithGoogle() async {
    try {
      await _ensureGoogleReady();
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final cred = await _auth.signInWithCredential(credential);
      return cred.user!;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelled();
      }
      // TEMP DIAGNOSTIC: surface the real code/description so we can see why the
      // release build fails. Revert to the generic message once fixed.
      throw AuthFailure(
        'Google sign-in failed [${e.code.name}] ${e.description ?? ''}',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    }
  }

  Future<void> _ensureGoogleReady() async {
    if (_googleReady) return;
    // On Android the Web client id is read from google-services.json. If
    // `idToken` ever comes back null, pass `serverClientId:` here explicitly.
    await _google.initialize();
    _googleReady = true;
  }

  // ----------------------------------------------------------------- logout

  /// LOG-06: clear both Firebase and Google sessions.
  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}

/// User cancelled an interactive flow (e.g. dismissed the Google sheet).
class AuthCancelled implements Exception {
  const AuthCancelled();
}

/// A user-presentable auth error. [message] is safe to show inline.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  factory AuthFailure.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const AuthFailure('An account with this email already exists.');
      case 'invalid-email':
        return const AuthFailure('That email address looks invalid.');
      case 'weak-password':
        return const AuthFailure('Password must be at least 8 characters.');
      case 'user-disabled':
        return const AuthFailure('This account has been disabled.');
      // LOG-04: do not reveal which field was wrong.
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
        return const AuthFailure('Incorrect email or password.');
      case 'too-many-requests':
        return const AuthFailure('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return const AuthFailure('No connection. Check your network.');
      default:
        return const AuthFailure('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}
