part of 'default.dart';

class ListSkillsByCategoryVariablesBuilder {
  String category;

  final FirebaseDataConnect _dataConnect;
  ListSkillsByCategoryVariablesBuilder(this._dataConnect, {required  this.category,});
  Deserializer<ListSkillsByCategoryData> dataDeserializer = (dynamic json)  => ListSkillsByCategoryData.fromJson(jsonDecode(json));
  Serializer<ListSkillsByCategoryVariables> varsSerializer = (ListSkillsByCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListSkillsByCategoryData, ListSkillsByCategoryVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListSkillsByCategoryData, ListSkillsByCategoryVariables> ref() {
    ListSkillsByCategoryVariables vars= ListSkillsByCategoryVariables(category: category,);
    return _dataConnect.query("ListSkillsByCategory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListSkillsByCategorySkills {
  final String id;
  final String name;
  final String category;
  ListSkillsByCategorySkills.fromJson(dynamic json):
  
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

    final ListSkillsByCategorySkills otherTyped = other as ListSkillsByCategorySkills;
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

  ListSkillsByCategorySkills({
    required this.id,
    required this.name,
    required this.category,
  });
}

@immutable
class ListSkillsByCategoryData {
  final List<ListSkillsByCategorySkills> skills;
  ListSkillsByCategoryData.fromJson(dynamic json):
  
  skills = (json['skills'] as List<dynamic>)
        .map((e) => ListSkillsByCategorySkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSkillsByCategoryData otherTyped = other as ListSkillsByCategoryData;
    return skills == otherTyped.skills;
    
  }
  @override
  int get hashCode => skills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['skills'] = skills.map((e) => e.toJson()).toList();
    return json;
  }

  ListSkillsByCategoryData({
    required this.skills,
  });
}

@immutable
class ListSkillsByCategoryVariables {
  final String category;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListSkillsByCategoryVariables.fromJson(Map<String, dynamic> json):
  
  category = nativeFromJson<String>(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSkillsByCategoryVariables otherTyped = other as ListSkillsByCategoryVariables;
    return category == otherTyped.category;
    
  }
  @override
  int get hashCode => category.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['category'] = nativeToJson<String>(category);
    return json;
  }

  ListSkillsByCategoryVariables({
    required this.category,
  });
}

