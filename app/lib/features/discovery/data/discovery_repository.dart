// Data Connect surface — see auth/data/profile_repository.dart for the codegen note.
import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/offering.dart';

/// Reads teachable offerings for Home browse and search (Module 3).
class DiscoveryRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  /// HOME-03: every teachable offering with its teacher + trust signals.
  Future<List<Offering>> listOfferings() async {
    final res = await _connector.listTeachOfferings().execute();
    return res.data.userSkills
        .map(
          (r) => Offering(
            skillId: r.skill.id,
            skillName: r.skill.name,
            category: r.skill.category,
            description: r.skill.description,
            teacherUid: r.user.uid,
            teacherName: r.user.name,
            teacherPhotoUrl: r.user.photoUrl,
            teacherRating: r.user.averageRating,
            teacherSessions: r.user.totalSessions,
            proficiency: r.proficiency,
          ),
        )
        .toList();
  }

  /// HOME-02: search offerings by skill name.
  Future<List<Offering>> searchOfferings(String query) async {
    final res = await _connector.searchTeachOfferings(q: query).execute();
    return res.data.userSkills
        .map(
          (r) => Offering(
            skillId: r.skill.id,
            skillName: r.skill.name,
            category: r.skill.category,
            description: r.skill.description,
            teacherUid: r.user.uid,
            teacherName: r.user.name,
            teacherPhotoUrl: r.user.photoUrl,
            teacherRating: r.user.averageRating,
            teacherSessions: r.user.totalSessions,
            proficiency: r.proficiency,
          ),
        )
        .toList();
  }
}
