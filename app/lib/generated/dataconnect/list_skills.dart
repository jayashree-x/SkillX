part of 'default.dart';

class ListSkillsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListSkillsVariablesBuilder(this._dataConnect, );
  Deserializer<ListSkillsData> dataDeserializer = (dynamic json)  => ListSkillsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListSkillsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListSkillsData, void> ref() {
    
    return _dataConnect.query("ListSkills", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListSkillsSkills {
  final String id;
  final String name;
  final String category;
  ListSkillsSkills.fromJson(dynamic json):
  
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

    final ListSkillsSkills otherTyped = other as ListSkillsSkills;
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

  ListSkillsSkills({
    required this.id,
    required this.name,
    required this.category,
  });
}

@immutable
class ListSkillsData {
  final List<ListSkillsSkills> skills;
  ListSkillsData.fromJson(dynamic json):
  
  skills = (json['skills'] as List<dynamic>)
        .map((e) => ListSkillsSkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSkillsData otherTyped = other as ListSkillsData;
    return skills == otherTyped.skills;
    
  }
  @override
  int get hashCode => skills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['skills'] = skills.map((e) => e.toJson()).toList();
    return json;
  }

  ListSkillsData({
    required this.skills,
  });
}

