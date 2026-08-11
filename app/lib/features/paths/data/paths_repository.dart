import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/learning_path.dart';

/// Data Connect reads for learning paths (Module 11).
class PathsRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  Future<List<PathSummary>> getMyPaths() async {
    final result = await _connector.getMyLearningPaths().execute();
    return result.data.userProgresses
        .map((p) => PathSummary(
              id: p.path.id,
              title: p.path.title,
              skillName: p.path.skill.name,
              totalModules: p.path.modules.length,
              unlockedUpTo: p.unlockedUpTo,
              isComplete: p.isPathComplete,
            ))
        .toList();
  }

  Future<List<ExplorePath>> listAllPaths() async {
    final result = await _connector.listLearningPaths().execute();
    return result.data.learningPaths
        .map((p) => ExplorePath(
              id: p.id,
              title: p.title,
              skillName: p.skill.name,
              teacherName: p.teacher.name,
              totalModules: p.modules.length,
            ))
        .toList();
  }

  Future<PathDetail?> getPathDetail(String pathId) async {
    final result = await _connector.getPathDetail(pathId: pathId).execute();
    final path = result.data.learningPath;
    if (path == null) return null;
    final progress = result.data.progress.isNotEmpty
        ? result.data.progress.first
        : null;
    return PathDetail(
      id: path.id,
      title: path.title,
      skillName: path.skill.name,
      teacherName: path.teacher.name,
      modules: path.modules
          .map((m) => PathModule(
                id: m.id,
                order: m.order,
                title: m.title,
                description: m.description,
              ))
          .toList(),
      unlockedUpTo: progress?.unlockedUpTo ?? 1,
      currentModuleOrder: progress?.currentModuleOrder ?? 1,
      isComplete: progress?.isPathComplete ?? false,
    );
  }

  /// The approved quiz tied to a module (via its session), or null if none yet.
  Future<String?> getModuleQuizId(String moduleId) async {
    final result = await _connector.getModuleQuiz(moduleId: moduleId).execute();
    for (final session in result.data.sessions) {
      if (session.quizzes.isNotEmpty) return session.quizzes.first.id;
    }
    return null;
  }
}
