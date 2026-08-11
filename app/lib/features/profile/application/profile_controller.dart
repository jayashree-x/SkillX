import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../auth/data/profile_repository.dart' show UserSkill;
import '../../skills/domain/skill_relation.dart';
import '../domain/resume_visibility.dart';
import 'profile_providers.dart';

final profileControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileController, void>(
        ProfileController.new);

/// Drives Profile edits: identity, resume upload/visibility/delete, and the
/// three skill sections.
class ProfileController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  String get _uid => ref.read(firebaseUserProvider).valueOrNull!.uid;

  /// PROF-08: save name / bio, uploading a new photo first if picked.
  Future<bool> saveIdentity({
    required String name,
    String? bio,
    Uint8List? photoBytes,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      String? photoUrl;
      if (photoBytes != null) {
        photoUrl = await ref
            .read(profilePhotoRepositoryProvider)
            .uploadProfilePhoto(uid: _uid, bytes: photoBytes);
      }
      await ref.read(userProfileRepositoryProvider).updateProfile(
            name: name,
            bio: bio,
            photoUrl: photoUrl,
          );
      ref.invalidate(myProfileProvider);
    });
    state = result;
    return !result.hasError;
  }

  /// PROF-13/17: upload the resume with progress, then record it.
  Future<bool> uploadResume({
    required String fileName,
    required Uint8List bytes,
    required ResumeVisibility visibility,
  }) async {
    state = const AsyncLoading();
    ref.read(resumeProgressProvider.notifier).state = 0;
    final result = await AsyncValue.guard(() async {
      final url = await ref.read(resumeRepositoryProvider).uploadResume(
            uid: _uid,
            bytes: bytes,
            onProgress: (p) =>
                ref.read(resumeProgressProvider.notifier).state = p,
          );
      await ref.read(userProfileRepositoryProvider).setResume(
            url: url,
            fileName: fileName,
            visibility: visibility,
          );
      ref.invalidate(myProfileProvider);
    });
    ref.read(resumeProgressProvider.notifier).state = null;
    state = result;
    return !result.hasError;
  }

  /// PROF-16: change resume visibility (keeps the existing file).
  Future<void> setResumeVisibility(ResumeVisibility visibility) async {
    final profile = ref.read(myProfileProvider).valueOrNull;
    if (profile == null || !profile.hasResume) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userProfileRepositoryProvider).setResume(
            url: profile.resumeUrl!,
            fileName: profile.resumeFileName ?? 'resume.pdf',
            visibility: visibility,
          );
      ref.invalidate(myProfileProvider);
    });
  }

  /// PROF-15: delete the file and clear its metadata.
  Future<void> deleteResume() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(resumeRepositoryProvider).deleteResume(_uid);
      await ref.read(userProfileRepositoryProvider).clearResume();
      ref.invalidate(myProfileProvider);
    });
  }

  /// Applies the desired skill sets per relation as add/remove diffs.
  Future<bool> saveSkills({
    required List<UserSkill> current,
    required Set<String> have,
    required Set<String> teach,
    required Set<String> learn,
  }) async {
    state = const AsyncLoading();
    final skills = ref.read(profileRepositoryProvider);
    final desired = {
      SkillRelation.have: have,
      SkillRelation.teach: teach,
      SkillRelation.learn: learn,
    };
    final existing = {
      for (final rel in SkillRelation.values) rel: <String>{},
    };
    for (final s in current) {
      existing[s.relation]!.add(s.skill.id);
    }

    final result = await AsyncValue.guard(() async {
      for (final rel in SkillRelation.values) {
        final want = desired[rel]!;
        final has = existing[rel]!;
        for (final id in want.difference(has)) {
          await skills.addSkill(skillId: id, relation: rel);
        }
        for (final id in has.difference(want)) {
          await skills.removeSkill(skillId: id, relation: rel);
        }
      }
      ref.invalidate(myProfileSkillsProvider);
    });
    state = result;
    return !result.hasError;
  }
}
