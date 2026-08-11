part of 'default.dart';

class GetMyTeachingSessionsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyTeachingSessionsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyTeachingSessionsData> dataDeserializer = (dynamic json)  => GetMyTeachingSessionsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyTeachingSessionsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyTeachingSessionsData, void> ref() {
    
    return _dataConnect.query("GetMyTeachingSessions", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyTeachingSessionsSessions {
  final String id;
  final String topic;
  final EnumValue<SessionLevel> level;
  final EnumValue<SessionStatus> status;
  final List<String>? plannedSubtopics;
  final List<String>? coveredSubtopics;
  GetMyTeachingSessionsSessions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']),
  level = sessionLevelDeserializer(json['level']),
  status = sessionStatusDeserializer(json['status']),
  plannedSubtopics = json['plannedSubtopics'] == null ? null : (json['plannedSubtopics'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  coveredSubtopics = json['coveredSubtopics'] == null ? null : (json['coveredSubtopics'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyTeachingSessionsSessions otherTyped = other as GetMyTeachingSessionsSessions;
    return id == otherTyped.id && 
    topic == otherTyped.topic && 
    level == otherTyped.level && 
    status == otherTyped.status && 
    plannedSubtopics == otherTyped.plannedSubtopics && 
    coveredSubtopics == otherTyped.coveredSubtopics;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode, level.hashCode, status.hashCode, plannedSubtopics.hashCode, coveredSubtopics.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
    json['level'] = 
    sessionLevelSerializer(level)
    ;
    json['status'] = 
    sessionStatusSerializer(status)
    ;
    if (plannedSubtopics != null) {
      json['plannedSubtopics'] = plannedSubtopics?.map((e) => nativeToJson<String>(e)).toList();
    }
    if (coveredSubtopics != null) {
      json['coveredSubtopics'] = coveredSubtopics?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  GetMyTeachingSessionsSessions({
    required this.id,
    required this.topic,
    required this.level,
    required this.status,
    this.plannedSubtopics,
    this.coveredSubtopics,
  });
}

@immutable
class GetMyTeachingSessionsData {
  final List<GetMyTeachingSessionsSessions> sessions;
  GetMyTeachingSessionsData.fromJson(dynamic json):
  
  sessions = (json['sessions'] as List<dynamic>)
        .map((e) => GetMyTeachingSessionsSessions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyTeachingSessionsData otherTyped = other as GetMyTeachingSessionsData;
    return sessions == otherTyped.sessions;
    
  }
  @override
  int get hashCode => sessions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessions'] = sessions.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyTeachingSessionsData({
    required this.sessions,
  });
}

