part of 'default.dart';

class GetModuleQuizVariablesBuilder {
  String moduleId;

  final FirebaseDataConnect _dataConnect;
  GetModuleQuizVariablesBuilder(this._dataConnect, {required  this.moduleId,});
  Deserializer<GetModuleQuizData> dataDeserializer = (dynamic json)  => GetModuleQuizData.fromJson(jsonDecode(json));
  Serializer<GetModuleQuizVariables> varsSerializer = (GetModuleQuizVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetModuleQuizData, GetModuleQuizVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetModuleQuizData, GetModuleQuizVariables> ref() {
    GetModuleQuizVariables vars= GetModuleQuizVariables(moduleId: moduleId,);
    return _dataConnect.query("GetModuleQuiz", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetModuleQuizSessions {
  final List<GetModuleQuizSessionsQuizzes> quizzes;
  GetModuleQuizSessions.fromJson(dynamic json):
  
  quizzes = (json['quizzes'] as List<dynamic>)
        .map((e) => GetModuleQuizSessionsQuizzes.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetModuleQuizSessions otherTyped = other as GetModuleQuizSessions;
    return quizzes == otherTyped.quizzes;
    
  }
  @override
  int get hashCode => quizzes.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['quizzes'] = quizzes.map((e) => e.toJson()).toList();
    return json;
  }

  GetModuleQuizSessions({
    required this.quizzes,
  });
}

@immutable
class GetModuleQuizSessionsQuizzes {
  final String id;
  final String topic;
  GetModuleQuizSessionsQuizzes.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetModuleQuizSessionsQuizzes otherTyped = other as GetModuleQuizSessionsQuizzes;
    return id == otherTyped.id && 
    topic == otherTyped.topic;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
    return json;
  }

  GetModuleQuizSessionsQuizzes({
    required this.id,
    required this.topic,
  });
}

@immutable
class GetModuleQuizData {
  final List<GetModuleQuizSessions> sessions;
  GetModuleQuizData.fromJson(dynamic json):
  
  sessions = (json['sessions'] as List<dynamic>)
        .map((e) => GetModuleQuizSessions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetModuleQuizData otherTyped = other as GetModuleQuizData;
    return sessions == otherTyped.sessions;
    
  }
  @override
  int get hashCode => sessions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sessions'] = sessions.map((e) => e.toJson()).toList();
    return json;
  }

  GetModuleQuizData({
    required this.sessions,
  });
}

@immutable
class GetModuleQuizVariables {
  final String moduleId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetModuleQuizVariables.fromJson(Map<String, dynamic> json):
  
  moduleId = nativeFromJson<String>(json['moduleId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetModuleQuizVariables otherTyped = other as GetModuleQuizVariables;
    return moduleId == otherTyped.moduleId;
    
  }
  @override
  int get hashCode => moduleId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['moduleId'] = nativeToJson<String>(moduleId);
    return json;
  }

  GetModuleQuizVariables({
    required this.moduleId,
  });
}

