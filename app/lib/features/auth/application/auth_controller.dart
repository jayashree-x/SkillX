import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../skills/domain/skill_relation.dart';
import '../data/auth_repository.dart';
import 'auth_providers.dart';

/// Drives every auth form action. Its [AsyncValue] state powers per-screen
/// spinners and inline error messages; screens read [AuthController.errorText].
final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, void>(AuthController.new);

class AuthController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthRepository get _auth => ref.read(authRepositoryProvider);

  /// REG-01..06: create the account, its Data Connect row, and attach skills.
  /// The router then routes to the verify-email screen (email not yet verified).
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required List<String> teachSkillIds,
    required List<String> learnSkillIds,
    Uint8List? photoBytes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _auth.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );

      // REG-07: upload the optional photo now that we have a uid.
      String? photoUrl;
      if (photoBytes != null) {
        photoUrl = await ref
            .read(profilePhotoRepositoryProvider)
            .uploadProfilePhoto(uid: user.uid, bytes: photoBytes);
      }

      final profile = ref.read(profileRepositoryProvider);
      await profile.upsertCurrentUser(
        name: name,
        email: email,
        photoUrl: photoUrl,
      );
      await _attachSkills(teachSkillIds, learnSkillIds);
      ref.invalidate(appAuthStateProvider);
    });
  }

  /// LOG-01: email/password sign-in.
  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _auth.signInWithEmail(email: email, password: password);
      ref.invalidate(appAuthStateProvider);
    });
  }

  /// LOG-02/08: request a reset email. The caller shows the same confirmation
  /// whether or not the address exists (LOG-09).
  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _auth.sendPasswordReset(email));
  }

  /// Google sign-in. A cancelled flow completes normally (no error surfaced);
  /// the router redirects on success (to onboarding or the app shell).
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final user = await _auth.signInWithGoogle();
        // Idempotently ensure the Data Connect user row exists from the Google
        // profile; skills are gathered on the complete-profile screen next.
        await ref.read(profileRepositoryProvider).upsertCurrentUser(
              name: user.displayName ?? 'SkillX user',
              email: user.email ?? '',
              photoUrl: user.photoURL,
            );
        ref.invalidate(appAuthStateProvider);
      } on AuthCancelled {
        // User backed out — leave state clean, no error.
      }
    });
  }

  /// Completes onboarding for a first-time Google user (REG-05/06).
  Future<void> completeProfile({
    required List<String> teachSkillIds,
    required List<String> learnSkillIds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _attachSkills(teachSkillIds, learnSkillIds);
      ref.invalidate(appAuthStateProvider);
    });
  }

  Future<void> resendVerificationEmail() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_auth.resendVerificationEmail);
  }

  /// Pull the latest verification state; the router redirects once verified.
  Future<void> refreshVerification() async {
    await _auth.reloadUser();
    ref.invalidate(appAuthStateProvider);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    ref.invalidate(appAuthStateProvider);
  }

  Future<void> _attachSkills(
    List<String> teachIds,
    List<String> learnIds,
  ) async {
    final profile = ref.read(profileRepositoryProvider);
    for (final id in teachIds) {
      await profile.addSkill(skillId: id, relation: SkillRelation.teach);
    }
    for (final id in learnIds) {
      await profile.addSkill(skillId: id, relation: SkillRelation.learn);
    }
  }

  /// Convenience for screens: the current inline error message, if any.
  static String? errorText(AsyncValue<void> state) {
    final error = state.error;
    if (error == null) return null;
    if (error is AuthFailure) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
