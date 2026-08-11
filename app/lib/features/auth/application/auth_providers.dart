import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../skills/data/skills_repository.dart';
import '../../skills/domain/skill_option.dart';
import '../data/auth_repository.dart';
import '../data/profile_photo_repository.dart';
import '../data/profile_repository.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => ProfileRepository());

final profilePhotoRepositoryProvider =
    Provider<ProfilePhotoRepository>((ref) => ProfilePhotoRepository());

final skillsRepositoryProvider =
    Provider<SkillsRepository>((ref) => SkillsRepository());

/// Live Firebase user (also fires on emailVerified / profile changes).
final firebaseUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

/// Where the user is in the auth journey — the single input to the router.
enum AuthStatus {
  /// Still resolving the first auth emission — show the splash.
  unknown,
  unauthenticated,
  needsVerification,
  needsProfile,
  ready,
}

/// Derives [AuthStatus] from the Firebase user + Data Connect profile.
final appAuthStateProvider = FutureProvider<AuthStatus>((ref) async {
  final userAsync = ref.watch(firebaseUserProvider);

  if (userAsync.isLoading && !userAsync.hasValue) {
    return AuthStatus.unknown;
  }

  final user = userAsync.valueOrNull;
  if (user == null) return AuthStatus.unauthenticated;

  // Password accounts must verify their email first (LOG-05). Google (and
  // other federated) sign-ins arrive already verified.
  final isPassword = user.providerData.any((p) => p.providerId == 'password');
  if (isPassword && !user.emailVerified) {
    return AuthStatus.needsVerification;
  }

  // Profile is complete once ≥1 teach + ≥1 learn skill exist (REG-05/06).
  // On a transient backend error, fall back to onboarding rather than crash;
  // re-adding skills is idempotent, so a complete user isn't harmed.
  try {
    final complete = await ref.watch(profileRepositoryProvider).hasMinimumSkills();
    return complete ? AuthStatus.ready : AuthStatus.needsProfile;
  } catch (_) {
    return AuthStatus.needsProfile;
  }
});

/// The skill catalogue for the registration / onboarding pickers.
final skillCatalogueProvider = FutureProvider<List<SkillOption>>(
  (ref) => ref.watch(skillsRepositoryProvider).listSkills(),
);
