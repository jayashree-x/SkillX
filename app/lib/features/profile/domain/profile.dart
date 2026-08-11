import 'resume_visibility.dart';

/// The signed-in user's full profile (Module 10): identity, teaching stats,
/// and resume metadata.
class Profile {
  const Profile({
    required this.name,
    required this.email,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalSessions,
    required this.averageRating,
    required this.resumeVisibility,
    this.bio,
    this.photoUrl,
    this.resumeUrl,
    this.resumeFileName,
    this.resumeUploadedAt,
  });

  final String name;
  final String email;
  final String? bio;
  final String? photoUrl;

  final int currentStreak;
  final int longestStreak;
  final int totalSessions;
  final double averageRating;

  final String? resumeUrl;
  final String? resumeFileName;
  final DateTime? resumeUploadedAt;
  final ResumeVisibility resumeVisibility;

  bool get hasResume => resumeUrl != null && resumeUrl!.isNotEmpty;
}
