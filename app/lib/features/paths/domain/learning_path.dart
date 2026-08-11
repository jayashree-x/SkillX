// Module 11 — Learning paths. Lock/unlock is driven entirely by unlockedUpTo:
// passing module N (>=40%) unlocks N+1 (server write), so modules below
// unlockedUpTo are passed, the one at it is current, and any above are locked
// (PATH-02/03).

enum ModuleState { completed, available, locked }

/// A path the learner is enrolled in, summarised for the list + progress bar.
class PathSummary {
  const PathSummary({
    required this.id,
    required this.title,
    required this.skillName,
    required this.totalModules,
    required this.unlockedUpTo,
    required this.isComplete,
  });

  final String id;
  final String title;
  final String skillName;
  final int totalModules;
  final int unlockedUpTo;
  final bool isComplete;

  int get completedModules {
    if (isComplete) return totalModules;
    return (unlockedUpTo - 1).clamp(0, totalModules);
  }

  double get progress =>
      totalModules == 0 ? 0 : completedModules / totalModules;
}

/// A path available to enrol in (Explore picker).
class ExplorePath {
  const ExplorePath({
    required this.id,
    required this.title,
    required this.skillName,
    required this.teacherName,
    required this.totalModules,
  });

  final String id;
  final String title;
  final String skillName;
  final String teacherName;
  final int totalModules;
}

class PathModule {
  const PathModule({
    required this.id,
    required this.order,
    required this.title,
    this.description,
  });

  final String id;
  final int order;
  final String title;
  final String? description;
}

/// Full path with the caller's progress, for the detail screen.
class PathDetail {
  const PathDetail({
    required this.id,
    required this.title,
    required this.skillName,
    required this.teacherName,
    required this.modules,
    required this.unlockedUpTo,
    required this.currentModuleOrder,
    required this.isComplete,
  });

  final String id;
  final String title;
  final String skillName;
  final String teacherName;
  final List<PathModule> modules;
  final int unlockedUpTo;
  final int currentModuleOrder;
  final bool isComplete;

  int get completedCount {
    if (isComplete) return modules.length;
    return (unlockedUpTo - 1).clamp(0, modules.length);
  }

  double get progress =>
      modules.isEmpty ? 0 : completedCount / modules.length;

  ModuleState stateOf(PathModule m) {
    if (isComplete || m.order < unlockedUpTo) return ModuleState.completed;
    if (m.order == unlockedUpTo) return ModuleState.available;
    return ModuleState.locked;
  }
}
