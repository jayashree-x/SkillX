part of 'default.dart';

class GetMyProgressVariablesBuilder {
  String pathId;

  final FirebaseDataConnect _dataConnect;
  GetMyProgressVariablesBuilder(this._dataConnect, {required  this.pathId,});
  Deserializer<GetMyProgressData> dataDeserializer = (dynamic json)  => GetMyProgressData.fromJson(jsonDecode(json));
  Serializer<GetMyProgressVariables> varsSerializer = (GetMyProgressVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMyProgressData, GetMyProgressVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyProgressData, GetMyProgressVariables> ref() {
    GetMyProgressVariables vars= GetMyProgressVariables(pathId: pathId,);
    return _dataConnect.query("GetMyProgress", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetMyProgressUserProgresses {
  final int currentModuleOrder;
  final int unlockedUpTo;
  final bool isPathComplete;
  final String? certificateId;
  GetMyProgressUserProgresses.fromJson(dynamic json):
  
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

    final GetMyProgressUserProgresses otherTyped = other as GetMyProgressUserProgresses;
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

  GetMyProgressUserProgresses({
    required this.currentModuleOrder,
    required this.unlockedUpTo,
    required this.isPathComplete,
    this.certificateId,
  });
}

@immutable
class GetMyProgressData {
  final List<GetMyProgressUserProgresses> userProgresses;
  GetMyProgressData.fromJson(dynamic json):
  
  userProgresses = (json['userProgresses'] as List<dynamic>)
        .map((e) => GetMyProgressUserProgresses.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyProgressData otherTyped = other as GetMyProgressData;
    return userProgresses == otherTyped.userProgresses;
    
  }
  @override
  int get hashCode => userProgresses.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userProgresses'] = userProgresses.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyProgressData({
    required this.userProgresses,
  });
}

@immutable
class GetMyProgressVariables {
  final String pathId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetMyProgressVariables.fromJson(Map<String, dynamic> json):
  
  pathId = nativeFromJson<String>(json['pathId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyProgressVariables otherTyped = other as GetMyProgressVariables;
    return pathId == otherTyped.pathId;
    
  }
  @override
  int get hashCode => pathId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pathId'] = nativeToJson<String>(pathId);
    return json;
  }

  GetMyProgressVariables({
    required this.pathId,
  });
}

