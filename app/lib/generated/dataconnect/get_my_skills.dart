part of 'default.dart';

class GetMySkillsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMySkillsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMySkillsData> dataDeserializer = (dynamic json)  => GetMySkillsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMySkillsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMySkillsData, void> ref() {
    
    return _dataConnect.query("GetMySkills", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMySkillsUserSkills {
  final EnumValue<SkillRelation> relation;
  final String? proficiency;
  final GetMySkillsUserSkillsSkill skill;
  GetMySkillsUserSkills.fromJson(dynamic json):
  
  relation = skillRelationDeserializer(json['relation']),
  proficiency = json['proficiency'] == null ? null : nativeFromJson<String>(json['proficiency']),
  skill = GetMySkillsUserSkillsSkill.fromJson(json['skill']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMySkillsUserSkills otherTyped = other as GetMySkillsUserSkills;
    return relation == otherTyped.relation && 
    proficiency == otherTyped.proficiency && 
    skill == otherTyped.skill;
    
  }
  @override
  int get hashCode => Object.hashAll([relation.hashCode, proficiency.hashCode, skill.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['relation'] = 
    skillRelationSerializer(relation)
    ;
    if (proficiency != null) {
      json['proficiency'] = nativeToJson<String?>(proficiency);
    }
    json['skill'] = skill.toJson();
    return json;
  }

  GetMySkillsUserSkills({
    required this.relation,
    this.proficiency,
    required this.skill,
  });
}

@immutable
class GetMySkillsUserSkillsSkill {
  final String id;
  final String name;
  final String category;
  GetMySkillsUserSkillsSkill.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  category = nativeFromJson<String>(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMySkillsUserSkillsSkill otherTyped = other as GetMySkillsUserSkillsSkill;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, category.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['category'] = nativeToJson<String>(category);
    return json;
  }

  GetMySkillsUserSkillsSkill({
    required this.id,
    required this.name,
    required this.category,
  });
}

@immutable
class GetMySkillsData {
  final List<GetMySkillsUserSkills> userSkills;
  GetMySkillsData.fromJson(dynamic json):
  
  userSkills = (json['userSkills'] as List<dynamic>)
        .map((e) => GetMySkillsUserSkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMySkillsData otherTyped = other as GetMySkillsData;
    return userSkills == otherTyped.userSkills;
    
  }
  @override
  int get hashCode => userSkills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userSkills'] = userSkills.map((e) => e.toJson()).toList();
    return json;
  }

  GetMySkillsData({
    required this.userSkills,
  });
}

