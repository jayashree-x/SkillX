part of 'default.dart';

class GetMyAttemptsVariablesBuilder {
  int limit;

  final FirebaseDataConnect _dataConnect;
  GetMyAttemptsVariablesBuilder(this._dataConnect, {required  this.limit,});
  Deserializer<GetMyAttemptsData> dataDeserializer = (dynamic json)  => GetMyAttemptsData.fromJson(jsonDecode(json));
  Serializer<GetMyAttemptsVariables> varsSerializer = (GetMyAttemptsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMyAttemptsData, GetMyAttemptsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyAttemptsData, GetMyAttemptsVariables> ref() {
    GetMyAttemptsVariables vars= GetMyAttemptsVariables(limit: limit,);
    return _dataConnect.query("GetMyAttempts", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetMyAttemptsQuizAttempts {
  final String id;
  final String skillName;
  final int score;
  final int totalQuestions;
  final double percentage;
  final String? badgeEarned;
  final Timestamp completedAt;
  GetMyAttemptsQuizAttempts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  skillName = nativeFromJson<String>(json['skillName']),
  score = nativeFromJson<int>(json['score']),
  totalQuestions = nativeFromJson<int>(json['totalQuestions']),
  percentage = nativeFromJson<double>(json['percentage']),
  badgeEarned = json['badgeEarned'] == null ? null : nativeFromJson<String>(json['badgeEarned']),
  completedAt = Timestamp.fromJson(json['completedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyAttemptsQuizAttempts otherTyped = other as GetMyAttemptsQuizAttempts;
    return id == otherTyped.id && 
    skillName == otherTyped.skillName && 
    score == otherTyped.score && 
    totalQuestions == otherTyped.totalQuestions && 
    percentage == otherTyped.percentage && 
    badgeEarned == otherTyped.badgeEarned && 
    completedAt == otherTyped.completedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, skillName.hashCode, score.hashCode, totalQuestions.hashCode, percentage.hashCode, badgeEarned.hashCode, completedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['skillName'] = nativeToJson<String>(skillName);
    json['score'] = nativeToJson<int>(score);
    json['totalQuestions'] = nativeToJson<int>(totalQuestions);
    json['percentage'] = nativeToJson<double>(percentage);
    if (badgeEarned != null) {
      json['badgeEarned'] = nativeToJson<String?>(badgeEarned);
    }
    json['completedAt'] = completedAt.toJson();
    return json;
  }

  GetMyAttemptsQuizAttempts({
    required this.id,
    required this.skillName,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    this.badgeEarned,
    required this.completedAt,
  });
}

@immutable
class GetMyAttemptsData {
  final List<GetMyAttemptsQuizAttempts> quizAttempts;
  GetMyAttemptsData.fromJson(dynamic json):
  
  quizAttempts = (json['quizAttempts'] as List<dynamic>)
        .map((e) => GetMyAttemptsQuizAttempts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyAttemptsData otherTyped = other as GetMyAttemptsData;
    return quizAttempts == otherTyped.quizAttempts;
    
  }
  @override
  int get hashCode => quizAttempts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['quizAttempts'] = quizAttempts.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyAttemptsData({
    required this.quizAttempts,
  });
}

@immutable
class GetMyAttemptsVariables {
  final int limit;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetMyAttemptsVariables.fromJson(Map<String, dynamic> json):
  
  limit = nativeFromJson<int>(json['limit']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyAttemptsVariables otherTyped = other as GetMyAttemptsVariables;
    return limit == otherTyped.limit;
    
  }
  @override
  int get hashCode => limit.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['limit'] = nativeToJson<int>(limit);
    return json;
  }

  GetMyAttemptsVariables({
    required this.limit,
  });
}

