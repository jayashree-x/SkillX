import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Resume PDF storage (PROF-10..17). One active file per user at
/// `resumes/{uid}/resume.pdf` — a new upload replaces the previous one
/// (matches storage.rules: owner-write, PDF, < 5 MB).
class ResumeRepository {
  ResumeRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Reference _ref(String uid) => _storage.ref('resumes/$uid/resume.pdf');

  /// Uploads [bytes] as the user's resume, reporting 0..1 progress (PROF-17),
  /// and returns the download URL.
  Future<String> uploadResume({
    required String uid,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
  }) async {
    final ref = _ref(uid);
    final task = ref.putData(
      bytes,
      SettableMetadata(contentType: 'application/pdf'),
    );
    if (onProgress != null) {
      task.snapshotEvents.listen((s) {
        if (s.totalBytes > 0) onProgress(s.bytesTransferred / s.totalBytes);
      });
    }
    await task;
    return ref.getDownloadURL();
  }

  Future<void> deleteResume(String uid) async {
    try {
      await _ref(uid).delete();
    } on FirebaseException catch (e) {
      // Already gone is fine — the DB metadata is the source of truth.
      if (e.code != 'object-not-found') rethrow;
    }
  }
}
