import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/paths_providers.dart';
import '../domain/learning_path.dart';

/// Module 11 — modules of one path with lock states. Passing a module's quiz
/// (>=40%) unlocks the next; skipping or failing keeps it locked (PATH-03/06).
class PathDetailScreen extends ConsumerWidget {
  const PathDetailScreen({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(pathDetailProvider(pathId));
    return Scaffold(
      appBar: AppBar(title: const Text('Path')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load path.')),
        data: (path) {
          if (path == null) {
            return const Center(child: Text('Path not found.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(pathDetailProvider(pathId)),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              children: [
                Text(
                  path.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${path.skillName} · ${path.teacherName}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                if (path.isComplete)
                  _CompleteBanner(
                    onGetCertificate: () =>
                        context.push('/certificate', extra: pathId),
                  ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: path.progress,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(
                      path.isComplete ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${path.completedCount} of ${path.modules.length} modules complete',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 20),
                for (final m in path.modules)
                  _ModuleTile(
                    module: m,
                    state: path.stateOf(m),
                    onTap: () => _onModuleTap(context, ref, path, m),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onModuleTap(
    BuildContext context,
    WidgetRef ref,
    PathDetail path,
    PathModule module,
  ) async {
    final state = path.stateOf(module);
    if (state == ModuleState.locked) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.lock_outline),
          title: const Text('Module locked'),
          content: Text(
            'Pass module ${module.order - 1} to unlock "${module.title}". '
            'Skipping keeps it locked.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Got it'),
            ),
          ],
        ),
      );
      return;
    }

    // Completed or available: open the module's quiz (retakes are unlimited).
    final quizId =
        await ref.read(pathsRepositoryProvider).getModuleQuizId(module.id);
    if (!context.mounted) return;
    if (quizId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No quiz has been released for this module yet.'),
        ),
      );
      return;
    }
    await context.push('/quiz-attempt', extra: quizId);
    ref
      ..invalidate(pathDetailProvider(pathId))
      ..invalidate(myLearningPathsProvider);
  }
}

class _CompleteBanner extends StatelessWidget {
  const _CompleteBanner({required this.onGetCertificate});

  final VoidCallback onGetCertificate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified, color: AppColors.success),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Path complete! Claim your participation certificate.',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onGetCertificate,
              icon: const Icon(Icons.workspace_premium, size: 18),
              label: const Text('Get certificate'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.module,
    required this.state,
    required this.onTap,
  });

  final PathModule module;
  final ModuleState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (state) {
      ModuleState.completed => (Icons.check_circle, AppColors.success),
      ModuleState.available => (Icons.play_circle_fill, AppColors.primary),
      ModuleState.locked => (Icons.lock, AppColors.textTertiary),
    };
    final locked = state == ModuleState.locked;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: locked ? 0.6 : 1,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state == ModuleState.available
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${module.order}. ${module.title}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (module.description != null &&
                            module.description!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            module.description!,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (state == ModuleState.available)
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 2),
                      child: Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
