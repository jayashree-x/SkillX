import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/paths_providers.dart';
import '../domain/learning_path.dart';

/// Module 11 — the learner's enrolled learning paths, each with a progress bar
/// (PATH-04). "Explore" enrols in a new path.
class LearningPathsScreen extends ConsumerWidget {
  const LearningPathsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myLearningPathsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning paths'),
        actions: [
          IconButton(
            tooltip: 'Explore paths',
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => _showExplore(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load paths.')),
        data: (paths) {
          if (paths.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.route_outlined,
                        size: 40, color: AppColors.textTertiary),
                    const SizedBox(height: 12),
                    const Text(
                      "You're not enrolled in any learning paths yet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showExplore(context, ref),
                      icon: const Icon(Icons.explore_outlined),
                      label: const Text('Explore paths'),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myLearningPathsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screen),
              itemCount: paths.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _PathCard(
                path: paths[i],
                onTap: () async {
                  await context.push('/path', extra: paths[i].id);
                  ref.invalidate(myLearningPathsProvider);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showExplore(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _ExploreSheet(),
    );
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({required this.path, required this.onTap});

  final PathSummary path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      path.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (path.isComplete)
                    const Icon(Icons.verified,
                        size: 20, color: AppColors.success),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                path.skillName,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
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
                '${path.completedModules} of ${path.totalModules} modules',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreSheet extends ConsumerWidget {
  const _ExploreSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(allPathsProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.lg),
        child: async.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Padding(
            padding: EdgeInsets.all(32),
            child: Text('Could not load paths.'),
          ),
          data: (paths) {
            if (paths.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Text('No learning paths are available yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textTertiary)),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Explore paths',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: paths.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _ExploreTile(path: paths[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ExploreTile extends ConsumerStatefulWidget {
  const _ExploreTile({required this.path});

  final ExplorePath path;

  @override
  ConsumerState<_ExploreTile> createState() => _ExploreTileState();
}

class _ExploreTileState extends ConsumerState<_ExploreTile> {
  bool _busy = false;

  Future<void> _enroll() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(pathsFunctionsRepositoryProvider)
          .enrollPath(widget.path.id);
      ref.invalidate(myLearningPathsProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
      await context.push('/path', extra: widget.path.id);
      ref.invalidate(myLearningPathsProvider);
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not enrol. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.path;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${p.skillName} · ${p.totalModules} modules · ${p.teacherName}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 34,
            child: _busy
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : ElevatedButton(
                    onPressed: _enroll,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      textStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Enrol'),
                  ),
          ),
        ],
      ),
    );
  }
}
