part of 'default.dart';

class AddMySkillVariablesBuilder {
  String skillId;
  SkillRelation relation;
  Optional<String> _proficiency = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  AddMySkillVariablesBuilder proficiency(String? t) {
   _proficiency.value = t;
   return this;
  }

  AddMySkillVariablesBuilder(this._dataConnect, {required  this.skillId,required  this.relation,});
  Deserializer<AddMySkillData> dataDeserializer = (dynamic json)  => AddMySkillData.fromJson(jsonDecode(json));
  Serializer<AddMySkillVariables> varsSerializer = (AddMySkillVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddMySkillData, AddMySkillVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddMySkillData, AddMySkillVariables> ref() {
    AddMySkillVariables vars= AddMySkillVariables(skillId: skillId,relation: relation,proficiency: _proficiency,);
    return _dataConnect.mutation("AddMySkill", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddMySkillUserSkillUpsert {
  final String userUid;
  final String skillId;
  final EnumValue<SkillRelation> relation;
  AddMySkillUserSkillUpsert.fromJson(dynamic json):
  
  userUid = nativeFromJson<String>(json['userUid']),
  skillId = nativeFromJson<String>(json['skillId']),
  relation = skillRelationDeserializer(json['relation']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddMySkillUserSkillUpsert otherTyped = other as AddMySkillUserSkillUpsert;
    return userUid == otherTyped.userUid && 
    skillId == otherTyped.skillId && 
    relation == otherTyped.relation;
    
  }
  @override
  int get hashCode => Object.hashAll([userUid.hashCode, skillId.hashCode, relation.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userUid'] = nativeToJson<String>(userUid);
    json['skillId'] = nativeToJson<String>(skillId);
    json['relation'] = 
    skillRelationSerializer(relation)
    ;
    return json;
  }

  AddMySkillUserSkillUpsert({
    required this.userUid,
    required this.skillId,
    required this.relation,
  });
}

@immutable
class AddMySkillData {
  final AddMySkillUserSkillUpsert userSkill_upsert;
  AddMySkillData.fromJson(dynamic json):
  
  userSkill_upsert = AddMySkillUserSkillUpsert.fromJson(json['userSkill_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddMySkillData otherTyped = other as AddMySkillData;
    return userSkill_upsert == otherTyped.userSkill_upsert;
    
  }
  @override
  int get hashCode => userSkill_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userSkill_upsert'] = userSkill_upsert.toJson();
    return json;
  }

  AddMySkillData({
    required this.userSkill_upsert,
  });
}

@immutable
class AddMySkillVariables {
  final String skillId;
  final SkillRelation relation;
  late final Optional<String>proficiency;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddMySkillVariables.fromJson(Map<String, dynamic> json):
  
  skillId = nativeFromJson<String>(json['skillId']),
  relation = SkillRelation.values.byName(json['relation']) {
  
  
  
  
    proficiency = Optional.optional(nativeFromJson, nativeToJson);
    proficiency.value = json['proficiency'] == null ? null : nativeFromJson<String>(json['proficiency']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddMySkillVariables otherTyped = other as AddMySkillVariables;
    return skillId == otherTyped.skillId && 
    relation == otherTyped.relation && 
    proficiency == otherTyped.proficiency;
    
  }
  @override
  int get hashCode => Object.hashAll([skillId.hashCode, relation.hashCode, proficiency.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['skillId'] = nativeToJson<String>(skillId);
    json['relation'] = 
    relation.name
    ;
    if(proficiency.state == OptionalState.set) {
      json['proficiency'] = proficiency.toJson();
    }
    return json;
  }

  AddMySkillVariables({
    required this.skillId,
    required this.relation,
    required this.proficiency,
  });
}

