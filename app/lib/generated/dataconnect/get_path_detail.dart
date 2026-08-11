part of 'default.dart';

class GetPathDetailVariablesBuilder {
  String pathId;

  final FirebaseDataConnect _dataConnect;
  GetPathDetailVariablesBuilder(this._dataConnect, {required  this.pathId,});
  Deserializer<GetPathDetailData> dataDeserializer = (dynamic json)  => GetPathDetailData.fromJson(jsonDecode(json));
  Serializer<GetPathDetailVariables> varsSerializer = (GetPathDetailVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPathDetailData, GetPathDetailVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetPathDetailData, GetPathDetailVariables> ref() {
    GetPathDetailVariables vars= GetPathDetailVariables(pathId: pathId,);
    return _dataConnect.query("GetPathDetail", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPathDetailLearningPath {
  final String id;
  final String title;
  final GetPathDetailLearningPathSkill skill;
  final GetPathDetailLearningPathTeacher teacher;
  final List<GetPathDetailLearningPathModules> modules;
  GetPathDetailLearningPath.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  skill = GetPathDetailLearningPathSkill.fromJson(json['skill']),
  teacher = GetPathDetailLearningPathTeacher.fromJson(json['teacher']),
  modules = (json['modules'] as List<dynamic>)
        .map((e) => GetPathDetailLearningPathModules.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailLearningPath otherTyped = other as GetPathDetailLearningPath;
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

  GetPathDetailLearningPath({
    required this.id,
    required this.title,
    required this.skill,
    required this.teacher,
    required this.modules,
  });
}

@immutable
class GetPathDetailLearningPathSkill {
  final String name;
  GetPathDetailLearningPathSkill.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailLearningPathSkill otherTyped = other as GetPathDetailLearningPathSkill;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetPathDetailLearningPathSkill({
    required this.name,
  });
}

@immutable
class GetPathDetailLearningPathTeacher {
  final String name;
  GetPathDetailLearningPathTeacher.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailLearningPathTeacher otherTyped = other as GetPathDetailLearningPathTeacher;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetPathDetailLearningPathTeacher({
    required this.name,
  });
}

@immutable
class GetPathDetailLearningPathModules {
  final String id;
  final int order;
  final String title;
  final String? description;
  GetPathDetailLearningPathModules.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  order = nativeFromJson<int>(json['order']),
  title = nativeFromJson<String>(json['title']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailLearningPathModules otherTyped = other as GetPathDetailLearningPathModules;
    return id == otherTyped.id && 
    order == otherTyped.order && 
    title == otherTyped.title && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, order.hashCode, title.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['order'] = nativeToJson<int>(order);
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  GetPathDetailLearningPathModules({
    required this.id,
    required this.order,
    required this.title,
    this.description,
  });
}

@immutable
class GetPathDetailProgress {
  final int currentModuleOrder;
  final int unlockedUpTo;
  final bool isPathComplete;
  final String? certificateId;
  GetPathDetailProgress.fromJson(dynamic json):
  
  currentModuleOrder = nativeFromJson<int>(json['currentModuleOrder']),
  unlockedUpTo = nativeFromJson<int>(json['unlockedUpTo']),
  isPathComplete = nativeFromJson<bool>(json['isPathComplete']),
  certificateId = json['certificateId'] == null ? null : nativeFromJson<String>(json['certificateId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailProgress otherTyped = other as GetPathDetailProgress;
    return currentModuleOrder == otherTyped.currentModuleOrder && 
    unlockedUpTo == otherTyped.unlockedUpTo && 
    isPathComplete == otherTyped.isPathComplete && 
    certificateId == otherTyped.certificateId;
    
  }
  @override
  int get hashCode => Object.hashAll([currentModuleOrder.hashCode, unlockedUpTo.hashCode, isPathComplete.hashCode, certificateId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['currentModuleOrder'] = nativeToJson<int>(currentModuleOrder);
    json['unlockedUpTo'] = nativeToJson<int>(unlockedUpTo);
    json['isPathComplete'] = nativeToJson<bool>(isPathComplete);
    if (certificateId != null) {
      json['certificateId'] = nativeToJson<String?>(certificateId);
    }
    return json;
  }

  GetPathDetailProgress({
    required this.currentModuleOrder,
    required this.unlockedUpTo,
    required this.isPathComplete,
    this.certificateId,
  });
}

@immutable
class GetPathDetailData {
  final GetPathDetailLearningPath? learningPath;
  final List<GetPathDetailProgress> progress;
  GetPathDetailData.fromJson(dynamic json):
  
  learningPath = json['learningPath'] == null ? null : GetPathDetailLearningPath.fromJson(json['learningPath']),
  progress = (json['progress'] as List<dynamic>)
        .map((e) => GetPathDetailProgress.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailData otherTyped = other as GetPathDetailData;
    return learningPath == otherTyped.learningPath && 
    progress == otherTyped.progress;
    
  }
  @override
  int get hashCode => Object.hashAll([learningPath.hashCode, progress.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (learningPath != null) {
      json['learningPath'] = learningPath!.toJson();
    }
    json['progress'] = progress.map((e) => e.toJson()).toList();
    return json;
  }

  GetPathDetailData({
    this.learningPath,
    required this.progress,
  });
}

@immutable
class GetPathDetailVariables {
  final String pathId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPathDetailVariables.fromJson(Map<String, dynamic> json):
  
  pathId = nativeFromJson<String>(json['pathId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathDetailVariables otherTyped = other as GetPathDetailVariables;
    return pathId == otherTyped.pathId;
    
  }
  @override
  int get hashCode => pathId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pathId'] = nativeToJson<String>(pathId);
    return json;
  }

  GetPathDetailVariables({
    required this.pathId,
  });
}

