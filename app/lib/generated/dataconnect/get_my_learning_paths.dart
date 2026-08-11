part of 'default.dart';

class GetMyLearningPathsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyLearningPathsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyLearningPathsData> dataDeserializer = (dynamic json)  => GetMyLearningPathsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyLearningPathsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyLearningPathsData, void> ref() {
    
    return _dataConnect.query("GetMyLearningPaths", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyLearningPathsUserProgresses {
  final int currentModuleOrder;
  final int unlockedUpTo;
  final bool isPathComplete;
  final GetMyLearningPathsUserProgressesPath path;
  GetMyLearningPathsUserProgresses.fromJson(dynamic json):
  
  currentModuleOrder = nativeFromJson<int>(json['currentModuleOrder']),
  unlockedUpTo = nativeFromJson<int>(json['unlockedUpTo']),
  isPathComplete = nativeFromJson<bool>(json['isPathComplete']),
  path = GetMyLearningPathsUserProgressesPath.fromJson(json['path']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyLearningPathsUserProgresses otherTyped = other as GetMyLearningPathsUserProgresses;
    return currentModuleOrder == otherTyped.currentModuleOrder && 
    unlockedUpTo == otherTyped.unlockedUpTo && 
    isPathComplete == otherTyped.isPathComplete && 
    path == otherTyped.path;
    
  }
  @override
  int get hashCode => Object.hashAll([currentModuleOrder.hashCode, unlockedUpTo.hashCode, isPathComplete.hashCode, path.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['currentModuleOrder'] = nativeToJson<int>(currentModuleOrder);
    json['unlockedUpTo'] = nativeToJson<int>(unlockedUpTo);
    json['isPathComplete'] = nativeToJson<bool>(isPathComplete);
    json['path'] = path.toJson();
    return json;
  }

  GetMyLearningPathsUserProgresses({
    required this.currentModuleOrder,
    required this.unlockedUpTo,
    required this.isPathComplete,
    required this.path,
  });
}

@immutable
class GetMyLearningPathsUserProgressesPath {
  final String id;
  final String title;
  final GetMyLearningPathsUserProgressesPathSkill skill;
  final List<GetMyLearningPathsUserProgressesPathModules> modules;
  GetMyLearningPathsUserProgressesPath.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  skill = GetMyLearningPathsUserProgressesPathSkill.fromJson(json['skill']),
  modules = (json['modules'] as List<dynamic>)
        .map((e) => GetMyLearningPathsUserProgressesPathModules.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyLearningPathsUserProgressesPath otherTyped = other as GetMyLearningPathsUserProgressesPath;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    skill == otherTyped.skill && 
    modules == otherTyped.modules;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, skill.hashCode, modules.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['skill'] = skill.toJson();
    json['modules'] = modules.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyLearningPathsUserProgressesPath({
    required this.id,
    required this.title,
    required this.skill,
    required this.modules,
  });
}

@immutable
class GetMyLearningPathsUserProgressesPathSkill {
  final String name;
  GetMyLearningPathsUserProgressesPathSkill.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyLearningPathsUserProgressesPathSkill otherTyped = other as GetMyLearningPathsUserProgressesPathSkill;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetMyLearningPathsUserProgressesPathSkill({
    required this.name,
  });
}

@immutable
class GetMyLearningPathsUserProgressesPathModules {
  final String id;
  GetMyLearningPathsUserProgressesPathModules.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyLearningPathsUserProgressesPathModules otherTyped = other as GetMyLearningPathsUserProgressesPathModules;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetMyLearningPathsUserProgressesPathModules({
    required this.id,
  });
}

@immutable
class GetMyLearningPathsData {
  final List<GetMyLearningPathsUserProgresses> userProgresses;
  GetMyLearningPathsData.fromJson(dynamic json):
  
  userProgresses = (json['userProgresses'] as List<dynamic>)
        .map((e) => GetMyLearningPathsUserProgresses.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyLearningPathsData otherTyped = other as GetMyLearningPathsData;
    return userProgresses == otherTyped.userProgresses;
    
  }
  @override
  int get hashCode => userProgresses.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userProgresses'] = userProgresses.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyLearningPathsData({
    required this.userProgresses,
  });
}

