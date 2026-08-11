part of 'default.dart';

class ListTeachOfferingsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListTeachOfferingsVariablesBuilder(this._dataConnect, );
  Deserializer<ListTeachOfferingsData> dataDeserializer = (dynamic json)  => ListTeachOfferingsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListTeachOfferingsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListTeachOfferingsData, void> ref() {
    
    return _dataConnect.query("ListTeachOfferings", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListTeachOfferingsUserSkills {
  final String? proficiency;
  final ListTeachOfferingsUserSkillsSkill skill;
  final ListTeachOfferingsUserSkillsUser user;
  ListTeachOfferingsUserSkills.fromJson(dynamic json):
  
  proficiency = json['proficiency'] == null ? null : nativeFromJson<String>(json['proficiency']),
  skill = ListTeachOfferingsUserSkillsSkill.fromJson(json['skill']),
  user = ListTeachOfferingsUserSkillsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachOfferingsUserSkills otherTyped = other as ListTeachOfferingsUserSkills;
    return proficiency == otherTyped.proficiency && 
    skill == otherTyped.skill && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([proficiency.hashCode, skill.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (proficiency != null) {
      json['proficiency'] = nativeToJson<String?>(proficiency);
    }
    json['skill'] = skill.toJson();
    json['user'] = user.toJson();
    return json;
  }

  ListTeachOfferingsUserSkills({
    this.proficiency,
    required this.skill,
    required this.user,
  });
}

@immutable
class ListTeachOfferingsUserSkillsSkill {
  final String id;
  final String name;
  final String category;
  final String? description;
  ListTeachOfferingsUserSkillsSkill.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  category = nativeFromJson<String>(json['category']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachOfferingsUserSkillsSkill otherTyped = other as ListTeachOfferingsUserSkillsSkill;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    category == otherTyped.category && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, category.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['category'] = nativeToJson<String>(category);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  ListTeachOfferingsUserSkillsSkill({
    required this.id,
    required this.name,
    required this.category,
    this.description,
  });
}

@immutable
class ListTeachOfferingsUserSkillsUser {
  final String uid;
  final String name;
  final String? photoUrl;
  final double averageRating;
  final int totalSessions;
  ListTeachOfferingsUserSkillsUser.fromJson(dynamic json):
  
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

    final ListTeachOfferingsUserSkillsUser otherTyped = other as ListTeachOfferingsUserSkillsUser;
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

  ListTeachOfferingsUserSkillsUser({
    required this.uid,
    required this.name,
    this.photoUrl,
    required this.averageRating,
    required this.totalSessions,
  });
}

@immutable
class ListTeachOfferingsData {
  final List<ListTeachOfferingsUserSkills> userSkills;
  ListTeachOfferingsData.fromJson(dynamic json):
  
  userSkills = (json['userSkills'] as List<dynamic>)
        .map((e) => ListTeachOfferingsUserSkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTeachOfferingsData otherTyped = other as ListTeachOfferingsData;
    return userSkills == otherTyped.userSkills;
    
  }
  @override
  int get hashCode => userSkills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userSkills'] = userSkills.map((e) => e.toJson()).toList();
    return json;
  }

  ListTeachOfferingsData({
    required this.userSkills,
  });
}

