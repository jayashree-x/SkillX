part of 'default.dart';

class GetMyUpcomingSessionsAsLearnerVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyUpcomingSessionsAsLearnerVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyUpcomingSessionsAsLearnerData> dataDeserializer = (dynamic json)  => GetMyUpcomingSessionsAsLearnerData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyUpcomingSessionsAsLearnerData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyUpcomingSessionsAsLearnerData, void> ref() {
    
    return _dataConnect.query("GetMyUpcomingSessionsAsLearner", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyUpcomingSessionsAsLearnerSessionLearners {
  final GetMyUpcomingSessionsAsLearnerSessionLearnersSession session;
  GetMyUpcomingSessionsAsLearnerSessionLearners.fromJson(dynamic json):
  
  session = GetMyUpcomingSessionsAsLearnerSessionLearnersSession.fromJson(json['session']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyUpcomingSessionsAsLearnerSessionLearners otherTyped = other as GetMyUpcomingSessionsAsLearnerSessionLearners;
    return session == otherTyped.session;
    
  }
  @override
  int get hashCode => session.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['session'] = session.toJson();
    return json;
  }

  GetMyUpcomingSessionsAsLearnerSessionLearners({
    required this.session,
  });
}

@immutable
class GetMyUpcomingSessionsAsLearnerSessionLearnersSession {
  final String id;
  final String topic;
  final EnumValue<SessionLevel> level;
  final int durationHours;
  final String? meetingLink;
  final Timestamp? scheduledAt;
  final EnumValue<SessionStatus> status;
  final GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher teacher;
  GetMyUpcomingSessionsAsLearnerSessionLearnersSession.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']),
  level = sessionLevelDeserializer(json['level']),
  durationHours = nativeFromJson<int>(json['durationHours']),
  meetingLink = json['meetingLink'] == null ? null : nativeFromJson<String>(json['meetingLink']),
  scheduledAt = json['scheduledAt'] == null ? null : Timestamp.fromJson(json['scheduledAt']),
  status = sessionStatusDeserializer(json['status']),
  teacher = GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher.fromJson(json['teacher']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyUpcomingSessionsAsLearnerSessionLearnersSession otherTyped = other as GetMyUpcomingSessionsAsLearnerSessionLearnersSession;
    return id == otherTyped.id && 
    topic == otherTyped.topic && 
    level == otherTyped.level && 
    durationHours == otherTyped.durationHours && 
    meetingLink == otherTyped.meetingLink && 
    scheduledAt == otherTyped.scheduledAt && 
    status == otherTyped.status && 
    teacher == otherTyped.teacher;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode, level.hashCode, durationHours.hashCode, meetingLink.hashCode, scheduledAt.hashCode, status.hashCode, teacher.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
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

  GetMyUpcomingSessionsAsLearnerSessionLearnersSession({
    required this.id,
    required this.topic,
    required this.level,
    required this.durationHours,
    this.meetingLink,
    this.scheduledAt,
    required this.status,
    required this.teacher,
  });
}

@immutable
class GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher {
  final String uid;
  final String name;
  final String? photoUrl;
  GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher.fromJson(dynamic json):
  
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

    final GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher otherTyped = other as GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher;
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

  GetMyUpcomingSessionsAsLearnerSessionLearnersSessionTeacher({
    required this.uid,
    required this.name,
    this.photoUrl,
  });
}

@immutable
class GetMyUpcomingSessionsAsLearnerData {
  final List<GetMyUpcomingSessionsAsLearnerSessionLearners> sessionLearners;
  GetMyUpcomingSessionsAsLearnerData.fromJson(dynamic json):
  
  sessionLearners = (json['sessionLearners'] as List<dynamic>)
        .map((e) => GetMyUpcomingSessionsAsLearnerSessionLearners.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyUpcomingSessionsAsLearnerData otherTyped = other as GetMyUpcomingSessionsAsLearnerData;
    return sessionLearners == otherTyped.sessionLearners;
    
  }
  @override
  int get hashCode => sessionLearners.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessionLearners'] = sessionLearners.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyUpcomingSessionsAsLearnerData({
    required this.sessionLearners,
  });
}

