import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/quiz_providers.dart';

/// Phase 6 teacher entry: the sessions you teach, to run the post-session form
/// and generate a quiz.
class TeachingSessionsScreen extends ConsumerWidget {
  const TeachingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myTeachingSessionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Teaching sessions')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load sessions.')),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No sessions yet. Start one from an accepted request on Home.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screen),
            itemCount: sessions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final s = sessions[i];
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
                          Text(
                            s.topic,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_title(s.level)} · ${_title(s.status)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (s.canRunQuiz)
                      ElevatedButton(
                        onPressed: () =>
                            context.push('/post-session-form', extra: s),
                        style: ElevatedButton.styleFrom(
                          // Theme sets buttons full-width; cap it here so the
                          // button doesn't starve the Expanded text in the Row.
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          textStyle: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Make quiz'),
                      )
                    else
                      const Text(
                        'Quiz created',
                        style: TextStyle(fontSize: 12, color: AppColors.teal),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _title(String enumName) =>
      enumName[0] + enumName.substring(1).toLowerCase();
}
