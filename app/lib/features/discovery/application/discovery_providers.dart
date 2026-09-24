import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../skills/domain/skill_relation.dart';
import '../../requests/application/requests_controller.dart';
import '../data/discovery_repository.dart';
import '../domain/offering.dart';

final discoveryRepositoryProvider =
    Provider<DiscoveryRepository>((ref) => DiscoveryRepository());

/// HOME-03 browse: all teachable offerings.
final offeringsProvider = FutureProvider<List<Offering>>(
  (ref) => ref.watch(discoveryRepositoryProvider).listOfferings(),
);

/// HOME-02 search results for a query (empty query → no results).
///
/// Filters the already-loaded browse list client-side, case-insensitively
/// (Postgres `contains` is case-sensitive, so "sql" never matched "SQL"). The
/// query is split into words and an offering matches when **every** word
/// appears somewhere in its skill name, teacher name, or category — so
/// "jayashree sql" or "public kowsalya" find results regardless of word order.
final offeringSearchProvider =
    FutureProvider.autoDispose.family<List<Offering>, String>((ref, query) async {
  final terms = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  if (terms.isEmpty) return const [];
  final offerings = await ref.watch(offeringsProvider.future);
  return offerings.where((o) {
    final haystack =
        '${o.skillName} ${o.teacherName} ${o.category}'.toLowerCase();
    return terms.every(haystack.contains);
  }).toList();
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

/// Teacher detail extras (reviews + trusted skills) for the offering screen.
final teacherExtrasProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, ({String teacherUid, String skillId})>(
  (ref, key) => ref
      .watch(functionsRepositoryProvider)
      .getTeacherExtras(key.teacherUid, skillId: key.skillId),
);
