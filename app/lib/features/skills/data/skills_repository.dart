// ===========================================================================
// Data Connect surface. See profile_repository.dart for the codegen note.
// ===========================================================================
import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/skill_option.dart';

/// Reads the shared skill catalogue (Data Connect `Skill` table).
class SkillsRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  /// ListSkills — the whole catalogue for the registration / onboarding
  /// pickers. Returns an empty list until the catalogue has been seeded.
  Future<List<SkillOption>> listSkills() async {
    final res = await _connector.listSkills().execute();
    return res.data.skills
        .map(
          (s) => SkillOption(
            id: s.id,
            name: s.name,
            category: s.category,
          ),
        )
        .toList();
  }
}
