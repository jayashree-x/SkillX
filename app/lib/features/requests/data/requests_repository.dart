// Data Connect surface — see auth/data/profile_repository.dart for the codegen note.
import 'package:skillx/generated/dataconnect/default.dart' as dc;

/// Skill-request actions (Module 3). Sending and accepting requests go through
/// Cloud Functions (see FunctionsRepository — the send also notifies the
/// teacher); this surface only covers rejecting.
class RequestsRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  Future<void> rejectRequest(String requestId) =>
      _connector.rejectRequest(requestId: requestId).execute();
}
