import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/profile_controller.dart';
import '../../application/profile_providers.dart';
import '../../domain/profile.dart';
import '../../domain/resume_visibility.dart';

const _maxBytes = 5 * 1024 * 1024;

/// Resume section (PROF-10..17): upload / view / replace / delete a PDF, with
/// a visibility control and an upload progress bar.
class ResumeCard extends ConsumerWidget {
  const ResumeCard({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(resumeProgressProvider);

    if (progress != null) {
      return _Shell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Uploading resume…',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress == 0 ? null : progress,
                minHeight: 6,
                backgroundColor: AppColors.fill,
              ),
            ),
          ],
        ),
      );
    }

    if (!profile.hasResume) {
      return _Shell(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _pickAndUpload(context, ref),
            icon: const Icon(Icons.upload_file_outlined, size: 18),
            label: const Text('Upload resume (PDF)'),
          ),
        ),
      );
    }

    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.picture_as_pdf_outlined,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.resumeFileName ?? 'resume.pdf',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (profile.resumeUploadedAt != null)
                      Text(
                        'Uploaded ${DateFormat('MMM d, yyyy').format(profile.resumeUploadedAt!)}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Action(
                icon: Icons.visibility_outlined,
                label: 'View',
                onTap: () => _open(context, profile.resumeUrl!),
              ),
              _Action(
                icon: Icons.autorenew,
                label: 'Replace',
                onTap: () => _pickAndUpload(context, ref),
              ),
              _Action(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: AppColors.error,
                onTap: () => _confirmDelete(context, ref),
              ),
            ],
          ),
          const Divider(height: 24),
          const Text('Who can see it',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final v in ResumeVisibility.values)
                ChoiceChip(
                  label: Text(v.label),
                  selected: profile.resumeVisibility == v,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    fontSize: 12.5,
                    color: profile.resumeVisibility == v
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: profile.resumeVisibility == v
                        ? AppColors.primary
                        : AppColors.borderStrong,
                  ),
                  onSelected: (_) => ref
                      .read(profileControllerProvider.notifier)
                      .setResumeVisibility(v),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context, WidgetRef ref) async {
    const pdfGroup = XTypeGroup(
      label: 'PDF',
      extensions: ['pdf'],
      mimeTypes: ['application/pdf'],
      uniformTypeIdentifiers: ['com.adobe.pdf'],
    );
    final file = await openFile(acceptedTypeGroups: [pdfGroup]);
    if (!context.mounted || file == null) return; // cancelled

    if (!file.name.toLowerCase().endsWith('.pdf')) {
      _snack(context, 'Please choose a PDF file.');
      return;
    }
    final bytes = await file.readAsBytes();
    if (!context.mounted) return;
    if (bytes.length > _maxBytes) {
      _snack(context, 'That file is over the 5 MB limit.');
      return;
    }

    final ok = await ref.read(profileControllerProvider.notifier).uploadResume(
          fileName: file.name,
          bytes: bytes,
          visibility: profile.resumeVisibility,
        );
    if (context.mounted && !ok) {
      final err = ref.read(profileControllerProvider).error;
      _snack(context, 'Upload failed: ${err ?? 'try again'}');
    }
  }

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) _snack(context, 'Could not open the resume.');
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete resume?'),
        content: const Text('This removes your uploaded resume for good.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (yes == true) {
      await ref.read(profileControllerProvider.notifier).deleteResume();
    }
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Icon(icon, size: 19, color: color),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
