import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/certificate.dart';
import 'certificate_functions_repository.dart';
import 'certificate_pdf.dart';

/// Orchestrates the full certificate flow: issue the (immutable) record, then —
/// if it has no PDF yet — generate one on-device, upload to Storage, and link
/// its URL back. Idempotent: an already-issued certificate is returned as-is.
class CertificateRepository {
  CertificateRepository(
    this._functions, {
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final CertificateFunctionsRepository _functions;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  Future<CertificateData> obtain(String pathId) async {
    var cert = await _functions.issueCertificate(pathId);
    if (cert.pdfUrl != null && cert.pdfUrl!.isNotEmpty) return cert;

    final uid = _auth.currentUser!.uid;
    final bytes = await buildCertificatePdf(cert);
    final ref = _storage.ref('certificates/$uid/${cert.id}.pdf');
    await ref.putData(bytes, SettableMetadata(contentType: 'application/pdf'));
    final url = await ref.getDownloadURL();
    final finalUrl = await _functions.attachPdf(cert.id, url);
    return cert.copyWith(pdfUrl: finalUrl);
  }
}
