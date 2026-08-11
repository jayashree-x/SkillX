part of 'default.dart';

class GetSessionVariablesBuilder {
  String sessionId;

  final FirebaseDataConnect _dataConnect;
  GetSessionVariablesBuilder(this._dataConnect, {required  this.sessionId,});
  Deserializer<GetSessionData> dataDeserializer = (dynamic json)  => GetSessionData.fromJson(jsonDecode(json));
  Serializer<GetSessionVariables> varsSerializer = (GetSessionVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetSessionData, GetSessionVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetSessionData, GetSessionVariables> ref() {
    GetSessionVariables vars= GetSessionVariables(sessionId: sessionId,);
    return _dataConnect.query("GetSession", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetSessionSession {
  final String id;
  final String topic;
  final List<String>? topicTags;
  final List<String>? plannedSubtopics;
  final List<String>? coveredSubtopics;
  final EnumValue<SessionLevel> level;
  final int durationHours;
  final String? meetingLink;
  final Timestamp? scheduledAt;
  final EnumValue<SessionStatus> status;
  final GetSessionSessionTeacher teacher;
  GetSessionSession.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']),
  topicTags = json['topicTags'] == null ? null : (json['topicTags'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  plannedSubtopics = json['plannedSubtopics'] == null ? null : (json['plannedSubtopics'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  coveredSubtopics = json['coveredSubtopics'] == null ? null : (json['coveredSubtopics'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  level = sessionLevelDeserializer(json['level']),
  durationHours = nativeFromJson<int>(json['durationHours']),
  meetingLink = json['meetingLink'] == null ? null : nativeFromJson<String>(json['meetingLink']),
  scheduledAt = json['scheduledAt'] == null ? null : Timestamp.fromJson(json['scheduledAt']),
  status = sessionStatusDeserializer(json['status']),
  teacher = GetSessionSessionTeacher.fromJson(json['teacher']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSessionSession otherTyped = other as GetSessionSession;
    return id == otherTyped.id && 
    topic == otherTyped.topic && 
    topicTags == otherTyped.topicTags && 
    plannedSubtopics == otherTyped.plannedSubtopics && 
    coveredSubtopics == otherTyped.coveredSubtopics && 
    level == otherTyped.level && 
    durationHours == otherTyped.durationHours && 
    meetingLink == otherTyped.meetingLink && 
    scheduledAt == otherTyped.scheduledAt && 
    status == otherTyped.status && 
    teacher == otherTyped.teacher;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode, topicTags.hashCode, plannedSubtopics.hashCode, coveredSubtopics.hashCode, level.hashCode, durationHours.hashCode, meetingLink.hashCode, scheduledAt.hashCode, status.hashCode, teacher.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
    if (topicTags != null) {
      json['topicTags'] = topicTags?.map((e) => nativeToJson<String>(e)).toList();
    }
    if (plannedSubtopics != null) {
      json['plannedSubtopics'] = plannedSubtopics?.map((e) => nativeToJson<String>(e)).toList();
    }
    if (coveredSubtopics != null) {
      json['coveredSubtopics'] = coveredSubtopics?.map((e) => nativeToJson<String>(e)).toList();
    }
    json['level'] = 
    sessionLevelSerializer(level)
    ;
    json['durationHours'] = nativeToJson<int>(durationHours);
    if (meetingLink != null) {
      json['meetingLink'] = nativeToJson<String?>(meetingLink);
    }
    if (scheduledAt != null) {
      json['scheduledAt'] = scheduledAt!.toJson();
    }
    json['status'] = 
    sessionStatusSerializer(status)
    ;
    json['teacher'] = teacher.toJson();
    return json;
  }

  GetSessionSession({
    required this.id,
    required this.topic,
    this.topicTags,
    this.plannedSubtopics,
    this.coveredSubtopics,
    required this.level,
    required this.durationHours,
    this.meetingLink,
    this.scheduledAt,
    required this.status,
    required this.teacher,
  });
}

@immutable
class GetSessionSessionTeacher {
  final String uid;
  final String name;
  final String? photoUrl;
  GetSessionSessionTeacher.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']),
  name = nativeFromJson<String>(json['name']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSessionSessionTeacher otherTyped = other as GetSessionSessionTeacher;
    return uid == otherTyped.uid && 
    name == otherTyped.name && 
    photoUrl == otherTyped.photoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([uid.hashCode, name.hashCode, photoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    json['name'] = nativeToJson<String>(name);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    return json;
  }

  GetSessionSessionTeacher({
    required this.uid,
    required this.name,
    this.photoUrl,
  });
}

@immutable
class GetSessionData {
  final GetSessionSession? session;
  GetSessionData.fromJson(dynamic json):
  
  session = json['session'] == null ? null : GetSessionSession.fromJson(json['session']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSessionData otherTyped = other as GetSessionData;
    return session == otherTyped.session;
    
  }
  @override
  int get hashCode => session.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (session != null) {
      json['session'] = session!.toJson();
    }
    return json;
  }

  GetSessionData({
    this.session,
  });
}

@immutable
class GetSessionVariables {
  final String sessionId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetSessionVariables.fromJson(Map<String, dynamic> json):
  
  sessionId = nativeFromJson<String>(json['sessionId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSessionVariables otherTyped = other as GetSessionVariables;
    return sessionId == otherTyped.sessionId;
    
  }
  @override
  int get hashCode => sessionId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessionId'] = nativeToJson<String>(sessionId);
    return json;
  }

  GetSessionVariables({
    required this.sessionId,
  });
}

