part of 'default.dart';

class ListLearningPathsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListLearningPathsVariablesBuilder(this._dataConnect, );
  Deserializer<ListLearningPathsData> dataDeserializer = (dynamic json)  => ListLearningPathsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListLearningPathsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListLearningPathsData, void> ref() {
    
    return _dataConnect.query("ListLearningPaths", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListLearningPathsLearningPaths {
  final String id;
  final String title;
  final ListLearningPathsLearningPathsSkill skill;
  final ListLearningPathsLearningPathsTeacher teacher;
  final List<ListLearningPathsLearningPathsModules> modules;
  ListLearningPathsLearningPaths.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  skill = ListLearningPathsLearningPathsSkill.fromJson(json['skill']),
  teacher = ListLearningPathsLearningPathsTeacher.fromJson(json['teacher']),
  modules = (json['modules'] as List<dynamic>)
        .map((e) => ListLearningPathsLearningPathsModules.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLearningPathsLearningPaths otherTyped = other as ListLearningPathsLearningPaths;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    skill == otherTyped.skill && 
    teacher == otherTyped.teacher && 
    modules == otherTyped.modules;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, skill.hashCode, teacher.hashCode, modules.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['skill'] = skill.toJson();
    json['teacher'] = teacher.toJson();
    json['modules'] = modules.map((e) => e.toJson()).toList();
    return json;
  }

  ListLearningPathsLearningPaths({
    required this.id,
    required this.title,
    required this.skill,
    required this.teacher,
    required this.modules,
  });
}

@immutable
class ListLearningPathsLearningPathsSkill {
  final String name;
  ListLearningPathsLearningPathsSkill.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLearningPathsLearningPathsSkill otherTyped = other as ListLearningPathsLearningPathsSkill;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  ListLearningPathsLearningPathsSkill({
    required this.name,
  });
}

@immutable
class ListLearningPathsLearningPathsTeacher {
  final String name;
  ListLearningPathsLearningPathsTeacher.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLearningPathsLearningPathsTeacher otherTyped = other as ListLearningPathsLearningPathsTeacher;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  ListLearningPathsLearningPathsTeacher({
    required this.name,
  });
}

@immutable
class ListLearningPathsLearningPathsModules {
  final String id;
  ListLearningPathsLearningPathsModules.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLearningPathsLearningPathsModules otherTyped = other as ListLearningPathsLearningPathsModules;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ListLearningPathsLearningPathsModules({
    required this.id,
  });
}

@immutable
class ListLearningPathsData {
  final List<ListLearningPathsLearningPaths> learningPaths;
  ListLearningPathsData.fromJson(dynamic json):
  
  learningPaths = (json['learningPaths'] as List<dynamic>)
        .map((e) => ListLearningPathsLearningPaths.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListLearningPathsData otherTyped = other as ListLearningPathsData;
    return learningPaths == otherTyped.learningPaths;
    
  }
  @override
  int get hashCode => learningPaths.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['learningPaths'] = learningPaths.map((e) => e.toJson()).toList();
    return json;
  }

  ListLearningPathsData({
    required this.learningPaths,
  });
}

