part of 'default.dart';

class GetMyOutgoingRequestsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyOutgoingRequestsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyOutgoingRequestsData> dataDeserializer = (dynamic json)  => GetMyOutgoingRequestsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyOutgoingRequestsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyOutgoingRequestsData, void> ref() {
    
    return _dataConnect.query("GetMyOutgoingRequests", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyOutgoingRequestsRequests {
  final String id;
  final EnumValue<RequestStatus> status;
  final Timestamp? preferredDateTime;
  final Timestamp createdAt;
  final GetMyOutgoingRequestsRequestsTeacher teacher;
  final GetMyOutgoingRequestsRequestsSkill skill;
  GetMyOutgoingRequestsRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  status = requestStatusDeserializer(json['status']),
  preferredDateTime = json['preferredDateTime'] == null ? null : Timestamp.fromJson(json['preferredDateTime']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  teacher = GetMyOutgoingRequestsRequestsTeacher.fromJson(json['teacher']),
  skill = GetMyOutgoingRequestsRequestsSkill.fromJson(json['skill']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyOutgoingRequestsRequests otherTyped = other as GetMyOutgoingRequestsRequests;
    return id == otherTyped.id && 
    status == otherTyped.status && 
    preferredDateTime == otherTyped.preferredDateTime && 
    createdAt == otherTyped.createdAt && 
    teacher == otherTyped.teacher && 
    skill == otherTyped.skill;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode, preferredDateTime.hashCode, createdAt.hashCode, teacher.hashCode, skill.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = 
    requestStatusSerializer(status)
    ;
    if (preferredDateTime != null) {
      json['preferredDateTime'] = preferredDateTime!.toJson();
    }
    json['createdAt'] = createdAt.toJson();
    json['teacher'] = teacher.toJson();
    json['skill'] = skill.toJson();
    return json;
  }

  GetMyOutgoingRequestsRequests({
    required this.id,
    required this.status,
    this.preferredDateTime,
    required this.createdAt,
    required this.teacher,
    required this.skill,
  });
}

@immutable
class GetMyOutgoingRequestsRequestsTeacher {
  final String uid;
  final String name;
  final String? photoUrl;
  GetMyOutgoingRequestsRequestsTeacher.fromJson(dynamic json):
  
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

    final GetMyOutgoingRequestsRequestsTeacher otherTyped = other as GetMyOutgoingRequestsRequestsTeacher;
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

  GetMyOutgoingRequestsRequestsTeacher({
    required this.uid,
    required this.name,
    this.photoUrl,
  });
}

@immutable
class GetMyOutgoingRequestsRequestsSkill {
  final String id;
  final String name;
  GetMyOutgoingRequestsRequestsSkill.fromJson(dynamic json):
  
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

    final GetMyOutgoingRequestsRequestsSkill otherTyped = other as GetMyOutgoingRequestsRequestsSkill;
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

  GetMyOutgoingRequestsRequestsSkill({
    required this.id,
    required this.name,
  });
}

@immutable
class GetMyOutgoingRequestsData {
  final List<GetMyOutgoingRequestsRequests> requests;
  GetMyOutgoingRequestsData.fromJson(dynamic json):
  
  requests = (json['requests'] as List<dynamic>)
        .map((e) => GetMyOutgoingRequestsRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyOutgoingRequestsData otherTyped = other as GetMyOutgoingRequestsData;
    return requests == otherTyped.requests;
    
  }
  @override
  int get hashCode => requests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['requests'] = requests.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyOutgoingRequestsData({
    required this.requests,
  });
}

