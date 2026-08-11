part of 'default.dart';

class RemoveMySkillVariablesBuilder {
  String skillId;
  SkillRelation relation;

  final FirebaseDataConnect _dataConnect;
  RemoveMySkillVariablesBuilder(this._dataConnect, {required  this.skillId,required  this.relation,});
  Deserializer<RemoveMySkillData> dataDeserializer = (dynamic json)  => RemoveMySkillData.fromJson(jsonDecode(json));
  Serializer<RemoveMySkillVariables> varsSerializer = (RemoveMySkillVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RemoveMySkillData, RemoveMySkillVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RemoveMySkillData, RemoveMySkillVariables> ref() {
    RemoveMySkillVariables vars= RemoveMySkillVariables(skillId: skillId,relation: relation,);
    return _dataConnect.mutation("RemoveMySkill", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RemoveMySkillUserSkillDelete {
  final String userUid;
  final String skillId;
  final EnumValue<SkillRelation> relation;
  RemoveMySkillUserSkillDelete.fromJson(dynamic json):
  
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

    final RemoveMySkillUserSkillDelete otherTyped = other as RemoveMySkillUserSkillDelete;
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

  RemoveMySkillUserSkillDelete({
    required this.userUid,
    required this.skillId,
    required this.relation,
  });
}

@immutable
class RemoveMySkillData {
  final RemoveMySkillUserSkillDelete? userSkill_delete;
  RemoveMySkillData.fromJson(dynamic json):
  
  userSkill_delete = json['userSkill_delete'] == null ? null : RemoveMySkillUserSkillDelete.fromJson(json['userSkill_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveMySkillData otherTyped = other as RemoveMySkillData;
    return userSkill_delete == otherTyped.userSkill_delete;
    
  }
  @override
  int get hashCode => userSkill_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (userSkill_delete != null) {
      json['userSkill_delete'] = userSkill_delete!.toJson();
    }
    return json;
  }

  RemoveMySkillData({
    this.userSkill_delete,
  });
}

@immutable
class RemoveMySkillVariables {
  final String skillId;
  final SkillRelation relation;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RemoveMySkillVariables.fromJson(Map<String, dynamic> json):
  
  skillId = nativeFromJson<String>(json['skillId']),
  relation = SkillRelation.values.byName(json['relation']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveMySkillVariables otherTyped = other as RemoveMySkillVariables;
    return skillId == otherTyped.skillId && 
    relation == otherTyped.relation;
    
  }
  @override
  int get hashCode => Object.hashAll([skillId.hashCode, relation.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['skillId'] = nativeToJson<String>(skillId);
    json['relation'] = 
    relation.name
    ;
    return json;
  }

  RemoveMySkillVariables({
    required this.skillId,
    required this.relation,
  });
}

