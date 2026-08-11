part of 'default.dart';

class ListTeachersForSkillVariablesBuilder {
  String skillId;

  final FirebaseDataConnect _dataConnect;
  ListTeachersForSkillVariablesBuilder(this._dataConnect, {required  this.skillId,});
  Deserializer<ListTeachersForSkillData> dataDeserializer = (dynamic json)  => ListTeachersForSkillData.fromJson(jsonDecode(json));
  Serializer<ListTeachersForSkillVariables> varsSerializer = (ListTeachersForSkillVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListTeachersForSkillData, ListTeachersForSkillVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListTeachersForSkillData, ListTeachersForSkillVariables> ref() {
    ListTeachersForSkillVariables vars= ListTeachersForSkillVariables(skillId: skillId,);
    return _dataConnect.query("ListTeachersForSkill", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListTeachersForSkillUserSkills {
  final ListTeachersForSkillUserSkillsUser user;
  ListTeachersForSkillUserSkills.fromJson(dynamic json):
  
  user = ListTeachersForSkillUserSkillsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachersForSkillUserSkills otherTyped = other as ListTeachersForSkillUserSkills;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  ListTeachersForSkillUserSkills({
    required this.user,
  });
}

@immutable
class ListTeachersForSkillUserSkillsUser {
  final String uid;
  final String name;
  final String? photoUrl;
  final double averageRating;
  final int totalSessions;
  ListTeachersForSkillUserSkillsUser.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']),
  name = nativeFromJson<String>(json['name']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  averageRating = nativeFromJson<double>(json['averageRating']),
  totalSessions = nativeFromJson<int>(json['totalSessions']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachersForSkillUserSkillsUser otherTyped = other as ListTeachersForSkillUserSkillsUser;
    return uid == otherTyped.uid && 
    name == otherTyped.name && 
    photoUrl == otherTyped.photoUrl && 
    averageRating == otherTyped.averageRating && 
    totalSessions == otherTyped.totalSessions;
    
  }
  @override
  int get hashCode => Object.hashAll([uid.hashCode, name.hashCode, photoUrl.hashCode, averageRating.hashCode, totalSessions.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    json['name'] = nativeToJson<String>(name);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['averageRating'] = nativeToJson<double>(averageRating);
    json['totalSessions'] = nativeToJson<int>(totalSessions);
    return json;
  }

  ListTeachersForSkillUserSkillsUser({
    required this.uid,
    required this.name,
    this.photoUrl,
    required this.averageRating,
    required this.totalSessions,
  });
}

@immutable
class ListTeachersForSkillData {
  final List<ListTeachersForSkillUserSkills> userSkills;
  ListTeachersForSkillData.fromJson(dynamic json):
  
  userSkills = (json['userSkills'] as List<dynamic>)
        .map((e) => ListTeachersForSkillUserSkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachersForSkillData otherTyped = other as ListTeachersForSkillData;
    return userSkills == otherTyped.userSkills;
    
  }
  @override
  int get hashCode => userSkills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userSkills'] = userSkills.map((e) => e.toJson()).toList();
    return json;
  }

  ListTeachersForSkillData({
    required this.userSkills,
  });
}

@immutable
class ListTeachersForSkillVariables {
  final String skillId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListTeachersForSkillVariables.fromJson(Map<String, dynamic> json):
  
  skillId = nativeFromJson<String>(json['skillId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachersForSkillVariables otherTyped = other as ListTeachersForSkillVariables;
    return skillId == otherTyped.skillId;
    
  }
  @override
  int get hashCode => skillId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['skillId'] = nativeToJson<String>(skillId);
    return json;
  }

  ListTeachersForSkillVariables({
    required this.skillId,
  });
}

