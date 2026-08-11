import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/rewards_repository.dart';
import '../domain/rewards_summary.dart';

final rewardsRepositoryProvider =
    Provider<RewardsRepository>((ref) => RewardsRepository());

/// Streak counters + earned badge tiers for the Rewards screen. Invalidated
/// after a graded quiz so newly-earned badges and streak days appear.
final rewardsSummaryProvider = FutureProvider<RewardsSummary>(
  (ref) => ref.watch(rewardsRepositoryProvider).fetch(),
);
