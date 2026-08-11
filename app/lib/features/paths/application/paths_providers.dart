import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/paths_functions_repository.dart';
import '../data/paths_repository.dart';
import '../domain/learning_path.dart';

final pathsRepositoryProvider =
    Provider<PathsRepository>((ref) => PathsRepository());

final pathsFunctionsRepositoryProvider =
    Provider<PathsFunctionsRepository>((ref) => PathsFunctionsRepository());

/// Paths the learner is enrolled in (list + progress bars).
final myLearningPathsProvider = FutureProvider<List<PathSummary>>(
  (ref) => ref.watch(pathsRepositoryProvider).getMyPaths(),
);

/// All paths available to enrol in (Explore picker).
final allPathsProvider = FutureProvider<List<ExplorePath>>(
  (ref) => ref.watch(pathsRepositoryProvider).listAllPaths(),
);

/// One path with the caller's progress; invalidated after a module quiz so
/// unlocks appear.
final pathDetailProvider = FutureProvider.family<PathDetail?, String>(
  (ref, pathId) => ref.watch(pathsRepositoryProvider).getPathDetail(pathId),
);
