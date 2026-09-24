// Data Connect surface — see auth/data/profile_repository.dart for the codegen note.
import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../../requests/domain/accepted_request.dart';
import '../domain/home_user.dart';
import '../domain/incoming_request.dart';
import '../domain/upcoming_session.dart';

/// Reads the Home screen's data: header identity/streak, incoming requests,
/// and upcoming sessions (Module 3).
class HomeRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  /// HOME-01: name, photo, streak for the header.
  Future<HomeUser> getCurrentUser() async {
    final res = await _connector.getCurrentUser().execute();
    final u = res.data.users.first;
    return HomeUser(
      name: u.name,
      photoUrl: u.photoUrl,
      currentStreak: u.currentStreak,
    );
  }

  /// HOME-06: the signed-in teacher's pending requests.
  Future<List<IncomingRequest>> getIncomingRequests() async {
    final res = await _connector.getIncomingRequests().execute();
    return res.data.requests
        .map(
          (r) => IncomingRequest(
            id: r.id,
            learnerUid: r.learner.uid,
            learnerName: r.learner.name,
            learnerPhotoUrl: r.learner.photoUrl,
            skillName: r.skill.name,
            message: r.message,
            preferredDateTime: r.preferredDateTime?.toDateTime().toLocal(),
            createdAt: r.createdAt.toDateTime().toLocal(),
          ),
        )
        .toList();
  }

  /// Phase 5: the teacher's accepted requests, ready to turn into sessions.
  Future<List<AcceptedTeachingRequest>> getAcceptedTeachingRequests() async {
    final res = await _connector.getMyAcceptedTeachingRequests().execute();
    return res.data.requests
        .map(
          (r) => AcceptedTeachingRequest(
            id: r.id,
            learnerUid: r.learner.uid,
            learnerName: r.learner.name,
            learnerPhotoUrl: r.learner.photoUrl,
            skillName: r.skill.name,
          ),
        )
        .toList();
  }

  /// HOME-09: confirmed sessions the user will attend as a learner.
  Future<List<UpcomingSession>> getUpcomingSessions() async {
    final res = await _connector.getMyUpcomingSessionsAsLearner().execute();
    return res.data.sessionLearners.map((sl) {
      final s = sl.session;
      return UpcomingSession(
        id: s.id,
        topic: s.topic,
        teacherName: s.teacher.name,
        teacherPhotoUrl: s.teacher.photoUrl,
        level: s.level.stringValue,
        durationHours: s.durationHours,
        status: s.status.stringValue,
        meetingLink: s.meetingLink,
        scheduledAt: s.scheduledAt?.toDateTime().toLocal(),
      );
    }).toList();
  }
}
