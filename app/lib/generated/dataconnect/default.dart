library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'upsert_current_user.dart';

part 'update_my_profile.dart';

part 'set_my_resume.dart';

part 'delete_my_resume.dart';

part 'set_my_fcm_token.dart';

part 'set_notification_prefs.dart';

part 'add_my_skill.dart';

part 'remove_my_skill.dart';

part 'reject_request.dart';

part 'get_current_user.dart';

part 'get_my_notification_prefs.dart';

part 'get_my_skills.dart';

part 'search_skills.dart';

part 'list_skills_by_category.dart';

part 'list_skills.dart';

part 'list_teachers_for_skill.dart';

part 'list_teach_offerings.dart';

part 'search_teach_offerings.dart';

part 'get_incoming_requests.dart';

part 'get_my_accepted_teaching_requests.dart';

part 'get_my_outgoing_requests.dart';

part 'get_my_upcoming_sessions_as_learner.dart';

part 'get_session.dart';

part 'get_my_teaching_sessions.dart';

part 'get_my_quizzes.dart';

part 'get_learner_quiz.dart';

part 'get_my_attempts.dart';

part 'get_my_progress.dart';

part 'get_my_learning_paths.dart';

part 'list_learning_paths.dart';

part 'get_path_detail.dart';

part 'get_module_quiz.dart';

part 'get_my_certificates.dart';



  enum RequestStatus {
    
      PENDING,
    
      ACCEPTED,
    
      REJECTED,
    
      COMPLETED,
    
  }
  
  String requestStatusSerializer(EnumValue<RequestStatus> e) {
    return e.stringValue;
  }
  EnumValue<RequestStatus> requestStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDING':
        return const Known(RequestStatus.PENDING);
      
      case 'ACCEPTED':
        return const Known(RequestStatus.ACCEPTED);
      
      case 'REJECTED':
        return const Known(RequestStatus.REJECTED);
      
      case 'COMPLETED':
        return const Known(RequestStatus.COMPLETED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum SessionLevel {
    
      BASIC,
    
      BEGINNER,
    
      INTERMEDIATE,
    
      ADVANCED,
    
  }
  
  String sessionLevelSerializer(EnumValue<SessionLevel> e) {
    return e.stringValue;
  }
  EnumValue<SessionLevel> sessionLevelDeserializer(dynamic data) {
    switch (data) {
      
      case 'BASIC':
        return const Known(SessionLevel.BASIC);
      
      case 'BEGINNER':
        return const Known(SessionLevel.BEGINNER);
      
      case 'INTERMEDIATE':
        return const Known(SessionLevel.INTERMEDIATE);
      
      case 'ADVANCED':
        return const Known(SessionLevel.ADVANCED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum SessionStatus {
    
      SCHEDULED,
    
      ONGOING,
    
      COMPLETED,
    
      CANCELLED,
    
  }
  
  String sessionStatusSerializer(EnumValue<SessionStatus> e) {
    return e.stringValue;
  }
  EnumValue<SessionStatus> sessionStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'SCHEDULED':
        return const Known(SessionStatus.SCHEDULED);
      
      case 'ONGOING':
        return const Known(SessionStatus.ONGOING);
      
      case 'COMPLETED':
        return const Known(SessionStatus.COMPLETED);
      
      case 'CANCELLED':
        return const Known(SessionStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum SkillRelation {
    
      HAVE,
    
      TEACH,
    
      LEARN,
    
  }
  
  String skillRelationSerializer(EnumValue<SkillRelation> e) {
    return e.stringValue;
  }
  EnumValue<SkillRelation> skillRelationDeserializer(dynamic data) {
    switch (data) {
      
      case 'HAVE':
        return const Known(SkillRelation.HAVE);
      
      case 'TEACH':
        return const Known(SkillRelation.TEACH);
      
      case 'LEARN':
        return const Known(SkillRelation.LEARN);
      
      default:
        return Unknown(data);
    }
  }
  



String enumSerializer(Enum e) {
  return e.name;
}



/// A sealed class representing either a known enum value or an unknown string value.
@immutable
sealed class EnumValue<T extends Enum> {
  const EnumValue();

  

  /// The string representation of the value.
  String get stringValue;
  @override
  String toString() {
    return "EnumValue($stringValue)";
  }
}

/// Represents a known, valid enum value.
class Known<T extends Enum> extends EnumValue<T> {
  /// The actual enum value.
  final T value;

  const Known(this.value);

  @override
  String get stringValue => value.name;

  @override
  String toString() {
    return "Known($stringValue)";
  }
}
/// Represents an unknown or unrecognized enum value.
class Unknown extends EnumValue<Never> {
  /// The raw string value that couldn't be mapped to a known enum.
  @override
  final String stringValue;

  const Unknown(this.stringValue);
  @override
  String toString() {
    return "Unknown($stringValue)";
  }
}

class DefaultConnector {
  
  
  UpsertCurrentUserVariablesBuilder upsertCurrentUser ({required String name, required String email, }) {
    return UpsertCurrentUserVariablesBuilder(dataConnect, name: name,email: email,);
  }
  
  
  UpdateMyProfileVariablesBuilder updateMyProfile () {
    return UpdateMyProfileVariablesBuilder(dataConnect, );
  }
  
  
  SetMyResumeVariablesBuilder setMyResume ({required String url, required String fileName, required String visibility, }) {
    return SetMyResumeVariablesBuilder(dataConnect, url: url,fileName: fileName,visibility: visibility,);
  }
  
  
  DeleteMyResumeVariablesBuilder deleteMyResume () {
    return DeleteMyResumeVariablesBuilder(dataConnect, );
  }
  
  
  SetMyFcmTokenVariablesBuilder setMyFcmToken ({required String token, }) {
    return SetMyFcmTokenVariablesBuilder(dataConnect, token: token,);
  }
  
  
  SetNotificationPrefsVariablesBuilder setNotificationPrefs ({required dynamic prefs, }) {
    return SetNotificationPrefsVariablesBuilder(dataConnect, prefs: prefs,);
  }
  
  
  AddMySkillVariablesBuilder addMySkill ({required String skillId, required SkillRelation relation, }) {
    return AddMySkillVariablesBuilder(dataConnect, skillId: skillId,relation: relation,);
  }
  
  
  RemoveMySkillVariablesBuilder removeMySkill ({required String skillId, required SkillRelation relation, }) {
    return RemoveMySkillVariablesBuilder(dataConnect, skillId: skillId,relation: relation,);
  }
  
  
  RejectRequestVariablesBuilder rejectRequest ({required String requestId, }) {
    return RejectRequestVariablesBuilder(dataConnect, requestId: requestId,);
  }
  
  
  GetCurrentUserVariablesBuilder getCurrentUser () {
    return GetCurrentUserVariablesBuilder(dataConnect, );
  }
  
  
  GetMyNotificationPrefsVariablesBuilder getMyNotificationPrefs () {
    return GetMyNotificationPrefsVariablesBuilder(dataConnect, );
  }
  
  
  GetMySkillsVariablesBuilder getMySkills () {
    return GetMySkillsVariablesBuilder(dataConnect, );
  }
  
  
  SearchSkillsVariablesBuilder searchSkills ({required String q, }) {
    return SearchSkillsVariablesBuilder(dataConnect, q: q,);
  }
  
  
  ListSkillsByCategoryVariablesBuilder listSkillsByCategory ({required String category, }) {
    return ListSkillsByCategoryVariablesBuilder(dataConnect, category: category,);
  }
  
  
  ListSkillsVariablesBuilder listSkills () {
    return ListSkillsVariablesBuilder(dataConnect, );
  }
  
  
  ListTeachersForSkillVariablesBuilder listTeachersForSkill ({required String skillId, }) {
    return ListTeachersForSkillVariablesBuilder(dataConnect, skillId: skillId,);
  }
  
  
  ListTeachOfferingsVariablesBuilder listTeachOfferings () {
    return ListTeachOfferingsVariablesBuilder(dataConnect, );
  }
  
  
  SearchTeachOfferingsVariablesBuilder searchTeachOfferings ({required String q, }) {
    return SearchTeachOfferingsVariablesBuilder(dataConnect, q: q,);
  }
  
  
  GetIncomingRequestsVariablesBuilder getIncomingRequests () {
    return GetIncomingRequestsVariablesBuilder(dataConnect, );
  }
  
  
  GetMyAcceptedTeachingRequestsVariablesBuilder getMyAcceptedTeachingRequests () {
    return GetMyAcceptedTeachingRequestsVariablesBuilder(dataConnect, );
  }
  
  
  GetMyOutgoingRequestsVariablesBuilder getMyOutgoingRequests () {
    return GetMyOutgoingRequestsVariablesBuilder(dataConnect, );
  }
  
  
  GetMyUpcomingSessionsAsLearnerVariablesBuilder getMyUpcomingSessionsAsLearner () {
    return GetMyUpcomingSessionsAsLearnerVariablesBuilder(dataConnect, );
  }
  
  
  GetSessionVariablesBuilder getSession ({required String sessionId, }) {
    return GetSessionVariablesBuilder(dataConnect, sessionId: sessionId,);
  }
  
  
  GetMyTeachingSessionsVariablesBuilder getMyTeachingSessions () {
    return GetMyTeachingSessionsVariablesBuilder(dataConnect, );
  }
  
  
  GetMyQuizzesVariablesBuilder getMyQuizzes () {
    return GetMyQuizzesVariablesBuilder(dataConnect, );
  }
  
  
  GetLearnerQuizVariablesBuilder getLearnerQuiz ({required String quizId, }) {
    return GetLearnerQuizVariablesBuilder(dataConnect, quizId: quizId,);
  }
  
  
  GetMyAttemptsVariablesBuilder getMyAttempts ({required int limit, }) {
    return GetMyAttemptsVariablesBuilder(dataConnect, limit: limit,);
  }
  
  
  GetMyProgressVariablesBuilder getMyProgress ({required String pathId, }) {
    return GetMyProgressVariablesBuilder(dataConnect, pathId: pathId,);
  }
  
  
  GetMyLearningPathsVariablesBuilder getMyLearningPaths () {
    return GetMyLearningPathsVariablesBuilder(dataConnect, );
  }
  
  
  ListLearningPathsVariablesBuilder listLearningPaths () {
    return ListLearningPathsVariablesBuilder(dataConnect, );
  }
  
  
  GetPathDetailVariablesBuilder getPathDetail ({required String pathId, }) {
    return GetPathDetailVariablesBuilder(dataConnect, pathId: pathId,);
  }
  
  
  GetModuleQuizVariablesBuilder getModuleQuiz ({required String moduleId, }) {
    return GetModuleQuizVariablesBuilder(dataConnect, moduleId: moduleId,);
  }
  
  
  GetMyCertificatesVariablesBuilder getMyCertificates () {
    return GetMyCertificatesVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'skillx',
  );

  DefaultConnector({required this.dataConnect});
  static DefaultConnector get instance {
    
    return DefaultConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
