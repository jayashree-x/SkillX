// Data Connect surface — see auth/data/profile_repository.dart for the codegen note.
import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/certificate.dart';
import '../domain/profile.dart';
import '../domain/resume_visibility.dart';

/// Reads/writes the Profile tab's data: identity + stats, resume metadata, and
/// certificates (Module 10).
class UserProfileRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  /// GetCurrentUser — the full profile for display.
  Future<Profile> getProfile() async {
    final res = await _connector.getCurrentUser().execute();
    final u = res.data.users.first;
    return Profile(
      name: u.name,
      email: u.email,
      bio: u.bio,
      photoUrl: u.photoUrl,
      currentStreak: u.currentStreak,
      longestStreak: u.longestStreak,
      totalSessions: u.totalSessions,
      averageRating: u.averageRating,
      resumeUrl: u.resumeUrl,
      resumeFileName: u.resumeFileName,
      resumeUploadedAt: u.resumeUploadedAt?.toDateTime().toLocal(),
      resumeVisibility: ResumeVisibility.fromValue(u.resumeVisibility),
    );
  }

  /// UpdateMyProfile — edit name / bio / photo (PROF-08).
  Future<void> updateProfile({String? name, String? bio, String? photoUrl}) async {
    final builder = _connector.updateMyProfile();
    if (name != null) builder.name(name);
    if (bio != null) builder.bio(bio);
    if (photoUrl != null) builder.photoUrl(photoUrl);
    await builder.execute();
  }

  /// SetMyResume — records the uploaded resume + its visibility (PROF-13/16).
  Future<void> setResume({
    required String url,
    required String fileName,
    required ResumeVisibility visibility,
  }) async {
    await _connector
        .setMyResume(url: url, fileName: fileName, visibility: visibility.value)
        .execute();
  }

  /// DeleteMyResume — clears the resume metadata (PROF-15).
  Future<void> clearResume() => _connector.deleteMyResume().execute();

  /// GetMyCertificates — earned certificates strip (PROF-07).
  Future<List<Certificate>> getCertificates() async {
    final res = await _connector.getMyCertificates().execute();
    return res.data.certificates
        .map(
          (c) => Certificate(
            id: c.id,
            skillName: c.skillName,
            teacherName: c.teacherName,
            averageScore: c.averageScore,
            modulesCompleted: c.modulesCompleted,
            pdfUrl: c.pdfUrl,
            issuedAt: c.issuedAt.toDateTime().toLocal(),
          ),
        )
        .toList();
  }
}
