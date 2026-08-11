part of 'default.dart';

class GetMyAcceptedTeachingRequestsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyAcceptedTeachingRequestsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyAcceptedTeachingRequestsData> dataDeserializer = (dynamic json)  => GetMyAcceptedTeachingRequestsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyAcceptedTeachingRequestsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyAcceptedTeachingRequestsData, void> ref() {
    
    return _dataConnect.query("GetMyAcceptedTeachingRequests", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyAcceptedTeachingRequestsRequests {
  final String id;
  final Timestamp? preferredDateTime;
  final String? message;
  final Timestamp createdAt;
  final GetMyAcceptedTeachingRequestsRequestsLearner learner;
  final GetMyAcceptedTeachingRequestsRequestsSkill skill;
  GetMyAcceptedTeachingRequestsRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  preferredDateTime = json['preferredDateTime'] == null ? null : Timestamp.fromJson(json['preferredDateTime']),
  message = json['message'] == null ? null : nativeFromJson<String>(json['message']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  learner = GetMyAcceptedTeachingRequestsRequestsLearner.fromJson(json['learner']),
  skill = GetMyAcceptedTeachingRequestsRequestsSkill.fromJson(json['skill']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyAcceptedTeachingRequestsRequests otherTyped = other as GetMyAcceptedTeachingRequestsRequests;
    return id == otherTyped.id && 
    preferredDateTime == otherTyped.preferredDateTime && 
    message == otherTyped.message && 
    createdAt == otherTyped.createdAt && 
    learner == otherTyped.learner && 
    skill == otherTyped.skill;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, preferredDateTime.hashCode, message.hashCode, createdAt.hashCode, learner.hashCode, skill.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (preferredDateTime != null) {
      json['preferredDateTime'] = preferredDateTime!.toJson();
    }
    if (message != null) {
      json['message'] = nativeToJson<String?>(message);
    }
    json['createdAt'] = createdAt.toJson();
    json['learner'] = learner.toJson();
    json['skill'] = skill.toJson();
    return json;
  }

  GetMyAcceptedTeachingRequestsRequests({
    required this.id,
    this.preferredDateTime,
    this.message,
    required this.createdAt,
    required this.learner,
    required this.skill,
  });
}

@immutable
class GetMyAcceptedTeachingRequestsRequestsLearner {
  final String uid;
  final String name;
  final String? photoUrl;
  GetMyAcceptedTeachingRequestsRequestsLearner.fromJson(dynamic json):
  
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

    final GetMyAcceptedTeachingRequestsRequestsLearner otherTyped = other as GetMyAcceptedTeachingRequestsRequestsLearner;
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

  GetMyAcceptedTeachingRequestsRequestsLearner({
    required this.uid,
    required this.name,
    this.photoUrl,
  });
}

@immutable
class GetMyAcceptedTeachingRequestsRequestsSkill {
  final String id;
  final String name;
  GetMyAcceptedTeachingRequestsRequestsSkill.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyAcceptedTeachingRequestsRequestsSkill otherTyped = other as GetMyAcceptedTeachingRequestsRequestsSkill;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetMyAcceptedTeachingRequestsRequestsSkill({
    required this.id,
    required this.name,
  });
}

@immutable
class GetMyAcceptedTeachingRequestsData {
  final List<GetMyAcceptedTeachingRequestsRequests> requests;
  GetMyAcceptedTeachingRequestsData.fromJson(dynamic json):
  
  requests = (json['requests'] as List<dynamic>)
        .map((e) => GetMyAcceptedTeachingRequestsRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyAcceptedTeachingRequestsData otherTyped = other as GetMyAcceptedTeachingRequestsData;
    return requests == otherTyped.requests;
    
  }
  @override
  int get hashCode => requests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['requests'] = requests.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyAcceptedTeachingRequestsData({
    required this.requests,
  });
}

