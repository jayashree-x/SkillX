import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/certificate.dart';

/// Builds the certificate PDF on-device (pure Dart — no native code). Wording is
/// deliberately participation-only, not an accreditation (CERT wording rule).
Future<Uint8List> buildCertificatePdf(CertificateData c) async {
  final doc = pw.Document();
  const primary = PdfColor.fromInt(0xFF2563EB);
  const teal = PdfColor.fromInt(0xFF0D9488);
  const ink = PdfColor.fromInt(0xFF0E1525);
  const soft = PdfColor.fromInt(0xFF64748B);
  final date = DateFormat('MMMM d, yyyy').format(c.issuedAt);

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: primary, width: 3),
        ),
        padding: const pw.EdgeInsets.all(6),
        child: pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: teal, width: 1),
          ),
          padding: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Column(children: [
                pw.Text('SkillX',
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: primary,
                        letterSpacing: 2)),
                pw.SizedBox(height: 6),
                pw.Text('CERTIFICATE OF PARTICIPATION',
                    style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: ink,
                        letterSpacing: 3)),
              ]),
              pw.Column(children: [
                pw.Text('This certifies that',
                    style: const pw.TextStyle(fontSize: 13, color: soft)),
                pw.SizedBox(height: 10),
                pw.Text(c.userName,
                    style: pw.TextStyle(
                        fontSize: 34,
                        fontWeight: pw.FontWeight.bold,
                        color: primary)),
                pw.SizedBox(height: 6),
                pw.Container(width: 260, height: 1, color: teal),
                pw.SizedBox(height: 18),
                pw.Text(
                  'has participated in and completed the',
                  style: const pw.TextStyle(fontSize: 13, color: soft),
                ),
                pw.SizedBox(height: 6),
                pw.Text('${c.skillName} learning path',
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: ink)),
                pw.SizedBox(height: 6),
                pw.Text(
                  'on SkillX, a peer-to-peer learning platform.',
                  style: const pw.TextStyle(fontSize: 12, color: soft),
                ),
              ]),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  _footItem('Peer mentor', c.teacherName),
                  _footItem('Modules', '${c.modulesCompleted} completed'),
                  _footItem('Avg. score', '${c.averageScore.round()}%'),
                  _footItem('Issued', date),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  return doc.save();
}

pw.Widget _footItem(String label, String value) {
  const ink = PdfColor.fromInt(0xFF0E1525);
  const soft = PdfColor.fromInt(0xFF94A3B8);
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(label.toUpperCase(),
          style: const pw.TextStyle(fontSize: 8, color: soft, letterSpacing: 1)),
      pw.SizedBox(height: 3),
      pw.Text(value,
          style: pw.TextStyle(
              fontSize: 12, fontWeight: pw.FontWeight.bold, color: ink)),
    ],
  );
}
