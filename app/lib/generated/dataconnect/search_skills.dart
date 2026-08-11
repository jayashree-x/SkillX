part of 'default.dart';

class SearchSkillsVariablesBuilder {
  String q;

  final FirebaseDataConnect _dataConnect;
  SearchSkillsVariablesBuilder(this._dataConnect, {required  this.q,});
  Deserializer<SearchSkillsData> dataDeserializer = (dynamic json)  => SearchSkillsData.fromJson(jsonDecode(json));
  Serializer<SearchSkillsVariables> varsSerializer = (SearchSkillsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchSkillsData, SearchSkillsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<SearchSkillsData, SearchSkillsVariables> ref() {
    SearchSkillsVariables vars= SearchSkillsVariables(q: q,);
    return _dataConnect.query("SearchSkills", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SearchSkillsSkills {
  final String id;
  final String name;
  final String category;
  final String? description;
  SearchSkillsSkills.fromJson(dynamic json):
  
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

    final SearchSkillsSkills otherTyped = other as SearchSkillsSkills;
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

  SearchSkillsSkills({
    required this.id,
    required this.name,
    required this.category,
    this.description,
  });
}

@immutable
class SearchSkillsData {
  final List<SearchSkillsSkills> skills;
  SearchSkillsData.fromJson(dynamic json):
  
  skills = (json['skills'] as List<dynamic>)
        .map((e) => SearchSkillsSkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchSkillsData otherTyped = other as SearchSkillsData;
    return skills == otherTyped.skills;
    
  }
  @override
  int get hashCode => skills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['skills'] = skills.map((e) => e.toJson()).toList();
    return json;
  }

  SearchSkillsData({
    required this.skills,
  });
}

@immutable
class SearchSkillsVariables {
  final String q;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SearchSkillsVariables.fromJson(Map<String, dynamic> json):
  
  q = nativeFromJson<String>(json['q']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchSkillsVariables otherTyped = other as SearchSkillsVariables;
    return q == otherTyped.q;
    
  }
  @override
  int get hashCode => q.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['q'] = nativeToJson<String>(q);
    return json;
  }

  SearchSkillsVariables({
    required this.q,
  });
}

