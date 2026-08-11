import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../auth/data/profile_repository.dart' show UserSkill;
import '../data/resume_repository.dart';
import '../data/user_profile_repository.dart';
import '../domain/certificate.dart';
import '../domain/profile.dart';

final userProfileRepositoryProvider =
    Provider<UserProfileRepository>((ref) => UserProfileRepository());

final resumeRepositoryProvider =
    Provider<ResumeRepository>((ref) => ResumeRepository());

/// Identity + stats + resume metadata (Module 10).
final myProfileProvider = FutureProvider<Profile>(
  (ref) => ref.watch(userProfileRepositoryProvider).getProfile(),
);

/// The three skill sections (PROF-02/03/04). Reuses the auth skills repo.
final myProfileSkillsProvider = FutureProvider<List<UserSkill>>(
  (ref) => ref.watch(profileRepositoryProvider).getMySkills(),
);

/// Earned certificates strip (PROF-07).
final myCertificatesProvider = FutureProvider<List<Certificate>>(
  (ref) => ref.watch(userProfileRepositoryProvider).getCertificates(),
);

/// Resume upload progress (0..1) while a transfer is in flight, else null.
final resumeProgressProvider = StateProvider<double?>((ref) => null);
