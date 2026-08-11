import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/certificate_providers.dart';
import '../data/certificate_pdf.dart';
import '../domain/certificate.dart';

/// Module 10 — certificate celebration. Issues + generates the PDF on open,
/// then offers share / view. Reached from a completed learning path.
class CertificateScreen extends ConsumerWidget {
  const CertificateScreen({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(certificateForPathProvider(pathId));
    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: async.when(
        loading: () => const _Generating(),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not create your certificate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(certificateForPathProvider(pathId)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (cert) => _CertificateView(cert: cert),
      ),
    );
  }
}

class _Generating extends StatelessWidget {
  const _Generating();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 18),
          Text('Preparing your certificate…',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _CertificateView extends StatelessWidget {
  const _CertificateView({required this.cert});

  final CertificateData cert;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMMM d, yyyy').format(cert.issuedAt);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.teal],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.workspace_premium,
                color: Colors.white, size: 46),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Congratulations,\n${cert.userName}!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.25,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You completed the ${cert.skillName} learning path.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _row('Skill', cert.skillName),
              _divider(),
              _row('Peer mentor', cert.teacherName),
              _divider(),
              _row('Modules completed', '${cert.modulesCompleted}'),
              _divider(),
              _row('Average score', '${cert.averageScore.round()}%'),
              _divider(),
              _row('Issued', date),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _share(context),
            icon: const Icon(Icons.ios_share, size: 20),
            label: const Text('Share certificate'),
          ),
        ),
        const SizedBox(height: 10),
        if (cert.pdfUrl != null)
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _open(cert.pdfUrl!),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
              label: const Text('View PDF'),
            ),
          ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Done'),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is a certificate of participation, not a formal accreditation.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13.5, color: AppColors.textSecondary)),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
          ],
        ),
      );

  Widget _divider() => const Divider(height: 1, color: AppColors.border);

  Future<void> _share(BuildContext context) async {
    final bytes = await buildCertificatePdf(cert);
    final safeSkill = cert.skillName.replaceAll(RegExp(r'[^A-Za-z0-9]'), '_');
    await Printing.sharePdf(bytes: bytes, filename: 'SkillX_$safeSkill.pdf');
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
