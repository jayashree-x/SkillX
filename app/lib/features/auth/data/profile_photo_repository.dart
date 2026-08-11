import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Uploads profile photos to Firebase Storage (REG-07). The path
/// `profilePhotos/{uid}/photo.jpg` matches storage.rules (owner-write, image,
/// < 5 MB, public read).
class ProfilePhotoRepository {
  ProfilePhotoRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadProfilePhoto({
    required String uid,
    required Uint8List bytes,
    String contentType = 'image/jpeg',
  }) async {
    final ref = _storage.ref('profilePhotos/$uid/photo.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }
}
