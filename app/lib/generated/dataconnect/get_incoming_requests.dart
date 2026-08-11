part of 'default.dart';

class GetIncomingRequestsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetIncomingRequestsVariablesBuilder(this._dataConnect, );
  Deserializer<GetIncomingRequestsData> dataDeserializer = (dynamic json)  => GetIncomingRequestsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetIncomingRequestsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetIncomingRequestsData, void> ref() {
    
    return _dataConnect.query("GetIncomingRequests", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetIncomingRequestsRequests {
  final String id;
  final EnumValue<RequestStatus> status;
  final Timestamp? preferredDateTime;
  final String? message;
  final Timestamp createdAt;
  final GetIncomingRequestsRequestsLearner learner;
  final GetIncomingRequestsRequestsSkill skill;
  GetIncomingRequestsRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  status = requestStatusDeserializer(json['status']),
  preferredDateTime = json['preferredDateTime'] == null ? null : Timestamp.fromJson(json['preferredDateTime']),
  message = json['message'] == null ? null : nativeFromJson<String>(json['message']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  learner = GetIncomingRequestsRequestsLearner.fromJson(json['learner']),
  skill = GetIncomingRequestsRequestsSkill.fromJson(json['skill']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetIncomingRequestsRequests otherTyped = other as GetIncomingRequestsRequests;
    return id == otherTyped.id && 
    status == otherTyped.status && 
    preferredDateTime == otherTyped.preferredDateTime && 
    message == otherTyped.message && 
    createdAt == otherTyped.createdAt && 
    learner == otherTyped.learner && 
    skill == otherTyped.skill;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode, preferredDateTime.hashCode, message.hashCode, createdAt.hashCode, learner.hashCode, skill.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = 
    requestStatusSerializer(status)
    ;
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

  GetIncomingRequestsRequests({
    required this.id,
    required this.status,
    this.preferredDateTime,
    this.message,
    required this.createdAt,
    required this.learner,
    required this.skill,
  });
}

@immutable
class GetIncomingRequestsRequestsLearner {
  final String uid;
  final String name;
  final String? photoUrl;
  GetIncomingRequestsRequestsLearner.fromJson(dynamic json):
  
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

    final GetIncomingRequestsRequestsLearner otherTyped = other as GetIncomingRequestsRequestsLearner;
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

  GetIncomingRequestsRequestsLearner({
    required this.uid,
    required this.name,
    this.photoUrl,
  });
}

@immutable
class GetIncomingRequestsRequestsSkill {
  final String id;
  final String name;
  GetIncomingRequestsRequestsSkill.fromJson(dynamic json):
  
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

    final GetIncomingRequestsRequestsSkill otherTyped = other as GetIncomingRequestsRequestsSkill;
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

  GetIncomingRequestsRequestsSkill({
    required this.id,
    required this.name,
  });
}

@immutable
class GetIncomingRequestsData {
  final List<GetIncomingRequestsRequests> requests;
  GetIncomingRequestsData.fromJson(dynamic json):
  
  requests = (json['requests'] as List<dynamic>)
        .map((e) => GetIncomingRequestsRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetIncomingRequestsData otherTyped = other as GetIncomingRequestsData;
    return requests == otherTyped.requests;
    
  }
  @override
  int get hashCode => requests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['requests'] = requests.map((e) => e.toJson()).toList();
    return json;
  }

  GetIncomingRequestsData({
    required this.requests,
  });
}

