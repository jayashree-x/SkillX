import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../domain/certificate.dart';

/// Calls the certificate Cloud Functions over HTTPS with the Firebase ID token.
class CertificateFunctionsRepository {
  static const _baseUrl = 'https://us-central1-skillx-9a717.cloudfunctions.net';

  Future<Map<String, dynamic>> _post(
    String name,
    Map<String, dynamic> body,
  ) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/$name'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      throw Exception('$name failed (${response.statusCode})');
    }
    return (jsonDecode(response.body) as Map).cast<String, dynamic>();
  }

  /// CERT-01: issue (or fetch the existing) certificate for a completed path.
  Future<CertificateData> issueCertificate(String pathId) async {
    final data = await _post('issueCertificate', {'pathId': pathId});
    return CertificateData.fromJson(data);
  }

  /// Links the uploaded PDF URL to the certificate (write-once).
  Future<String> attachPdf(String certificateId, String pdfUrl) async {
    final data = await _post('attachCertificatePdf', {
      'certificateId': certificateId,
      'pdfUrl': pdfUrl,
    });
    return data['pdfUrl'] as String;
  }
}
