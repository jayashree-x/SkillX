/// Who can see the uploaded resume (PROF-16). Stored on the user row as a
/// string; the enum drives the picker labels.
enum ResumeVisibility {
  public,
  matchedOnly,
  private;

  /// Value persisted in Data Connect.
  String get value => switch (this) {
        ResumeVisibility.public => 'public',
        ResumeVisibility.matchedOnly => 'matchedOnly',
        ResumeVisibility.private => 'private',
      };

  String get label => switch (this) {
        ResumeVisibility.public => 'Everyone',
        ResumeVisibility.matchedOnly => 'Matched users',
        ResumeVisibility.private => 'Only me',
      };

  static ResumeVisibility fromValue(String value) => switch (value) {
        'public' => ResumeVisibility.public,
        'private' => ResumeVisibility.private,
        _ => ResumeVisibility.matchedOnly,
      };
}
