import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';
import '../domain/dashboard_data.dart';

final dashboardRepositoryProvider =
    Provider<DashboardRepository>((ref) => DashboardRepository());

final dashboardDataProvider = FutureProvider<DashboardData>(
  (ref) => ref.watch(dashboardRepositoryProvider).fetch(),
);
