part of 'default.dart';

class GetMyQuizzesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyQuizzesVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyQuizzesData> dataDeserializer = (dynamic json)  => GetMyQuizzesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyQuizzesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyQuizzesData, void> ref() {
    
    return _dataConnect.query("GetMyQuizzes", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyQuizzesSessionLearners {
  final GetMyQuizzesSessionLearnersSession session;
  GetMyQuizzesSessionLearners.fromJson(dynamic json):
  
  session = GetMyQuizzesSessionLearnersSession.fromJson(json['session']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyQuizzesSessionLearners otherTyped = other as GetMyQuizzesSessionLearners;
    return session == otherTyped.session;
    
  }
  @override
  int get hashCode => session.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['session'] = session.toJson();
    return json;
  }

  GetMyQuizzesSessionLearners({
    required this.session,
  });
}

@immutable
class GetMyQuizzesSessionLearnersSession {
  final String id;
  final String topic;
  final List<GetMyQuizzesSessionLearnersSessionQuizzes> quizzes;
  GetMyQuizzesSessionLearnersSession.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']),
  quizzes = (json['quizzes'] as List<dynamic>)
        .map((e) => GetMyQuizzesSessionLearnersSessionQuizzes.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyQuizzesSessionLearnersSession otherTyped = other as GetMyQuizzesSessionLearnersSession;
    return id == otherTyped.id && 
    topic == otherTyped.topic && 
    quizzes == otherTyped.quizzes;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode, quizzes.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
    json['quizzes'] = quizzes.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyQuizzesSessionLearnersSession({
    required this.id,
    required this.topic,
    required this.quizzes,
  });
}

@immutable
class GetMyQuizzesSessionLearnersSessionQuizzes {
  final String id;
  final String topic;
  final EnumValue<SessionLevel> level;
  GetMyQuizzesSessionLearnersSessionQuizzes.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']),
  level = sessionLevelDeserializer(json['level']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyQuizzesSessionLearnersSessionQuizzes otherTyped = other as GetMyQuizzesSessionLearnersSessionQuizzes;
    return id == otherTyped.id && 
    topic == otherTyped.topic && 
    level == otherTyped.level;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode, level.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
    json['level'] = 
    sessionLevelSerializer(level)
    ;
    return json;
  }

  GetMyQuizzesSessionLearnersSessionQuizzes({
    required this.id,
    required this.topic,
    required this.level,
  });
}

@immutable
class GetMyQuizzesData {
  final List<GetMyQuizzesSessionLearners> sessionLearners;
  GetMyQuizzesData.fromJson(dynamic json):
  
  sessionLearners = (json['sessionLearners'] as List<dynamic>)
        .map((e) => GetMyQuizzesSessionLearners.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyQuizzesData otherTyped = other as GetMyQuizzesData;
    return sessionLearners == otherTyped.sessionLearners;
    
  }
  @override
  int get hashCode => sessionLearners.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessionLearners'] = sessionLearners.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyQuizzesData({
    required this.sessionLearners,
  });
}

