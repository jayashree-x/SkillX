import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../home/application/home_providers.dart';
import '../../notifications/data/fcm_service.dart';
import '../data/functions_repository.dart';

final functionsRepositoryProvider =
    Provider<FunctionsRepository>((ref) => FunctionsRepository());

final fcmServiceProvider =
    Provider<FcmService>((ref) => FcmService(ref.read(profileRepositoryProvider)));

/// Drives send / accept / reject actions and refreshes the incoming list.
final requestsControllerProvider =
    AutoDisposeAsyncNotifierProvider<RequestsController, void>(
        RequestsController.new);

class RequestsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// HOME-05: send a request. Returns true on success.
  Future<bool> sendRequest({
    required String teacherUid,
    required String skillId,
    DateTime? preferredDateTime,
    String? message,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(functionsRepositoryProvider).sendRequest(
            teacherUid: teacherUid,
            skillId: skillId,
            preferredDateTime: preferredDateTime,
            message: message,
          ),
    );
    state = result;
    return !result.hasError;
  }

  /// HOME-06: accept via the Cloud Function (ACCEPTED + opens chat + notifies).
  /// Returns the 1:1 chat id (null on failure) so the caller can open the chat.
  Future<String?> accept(String requestId) async {
    state = const AsyncLoading();
    String? chatId;
    state = await AsyncValue.guard(() async {
      chatId = await ref.read(functionsRepositoryProvider).acceptRequest(requestId);
      ref
        ..invalidate(incomingRequestsProvider)
        ..invalidate(acceptedTeachingRequestsProvider);
    });
    return state.hasError ? null : chatId;
  }

  /// Pre-Session Form submit → createSession Cloud Function. Returns true on
  /// success.
  Future<bool> createSession({
    required String requestId,
    required List<String> learnerUids,
    required String topic,
    required List<String> topicTags,
    required List<String> plannedSubtopics,
    required String level,
    required int durationHours,
    DateTime? scheduledAt,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref.read(functionsRepositoryProvider).createSession(
            requestId: requestId,
            learnerUids: learnerUids,
            topic: topic,
            topicTags: topicTags,
            plannedSubtopics: plannedSubtopics,
            level: level,
            durationHours: durationHours,
            scheduledAt: scheduledAt,
          );
      ref
        ..invalidate(acceptedTeachingRequestsProvider)
        ..invalidate(upcomingSessionsProvider);
    });
    state = result;
    return !result.hasError;
  }

  /// HOME-06: reject via the Cloud Function (REJECTED + notifies the learner).
  Future<void> reject(String requestId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(functionsRepositoryProvider).rejectRequest(requestId);
      ref.invalidate(incomingRequestsProvider);
    });
  }
}
