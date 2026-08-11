import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../requests/domain/accepted_request.dart';
import '../data/home_repository.dart';
import '../domain/home_user.dart';
import '../domain/incoming_request.dart';
import '../domain/upcoming_session.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) => HomeRepository());

/// HOME-01 header (name, photo, streak).
final currentHomeUserProvider = FutureProvider<HomeUser>(
  (ref) => ref.watch(homeRepositoryProvider).getCurrentUser(),
);

/// HOME-06 incoming pending requests.
final incomingRequestsProvider = FutureProvider<List<IncomingRequest>>(
  (ref) => ref.watch(homeRepositoryProvider).getIncomingRequests(),
);

/// HOME-09 upcoming sessions (view/join surface).
final upcomingSessionsProvider = FutureProvider<List<UpcomingSession>>(
  (ref) => ref.watch(homeRepositoryProvider).getUpcomingSessions(),
);

/// Phase 5: accepted requests the teacher can start a session from.
final acceptedTeachingRequestsProvider =
    FutureProvider<List<AcceptedTeachingRequest>>(
  (ref) => ref.watch(homeRepositoryProvider).getAcceptedTeachingRequests(),
);
