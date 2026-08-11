import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../skills/domain/skill_relation.dart';
import '../data/discovery_repository.dart';
import '../domain/offering.dart';

final discoveryRepositoryProvider =
    Provider<DiscoveryRepository>((ref) => DiscoveryRepository());

/// HOME-03 browse: all teachable offerings.
final offeringsProvider = FutureProvider<List<Offering>>(
  (ref) => ref.watch(discoveryRepositoryProvider).listOfferings(),
);

/// HOME-02 search results for a query (empty query → no results).
final offeringSearchProvider =
    FutureProvider.autoDispose.family<List<Offering>, String>((ref, query) async {
  final q = query.trim();
  if (q.isEmpty) return const [];
  return ref.watch(discoveryRepositoryProvider).searchOfferings(q);
});

/// Skill ids the user wants to learn — drives the "matches your want-to-learn"
/// indicator on skill detail (HOME-10 / skill detail mockup).
final myLearnSkillIdsProvider = FutureProvider<Set<String>>((ref) async {
  final skills = await ref.watch(profileRepositoryProvider).getMySkills();
  return skills
      .where((s) => s.relation == SkillRelation.learn)
      .map((s) => s.skill.id)
      .toSet();
});
