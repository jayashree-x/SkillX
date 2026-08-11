part of 'default.dart';

class SetMyResumeVariablesBuilder {
  String url;
  String fileName;
  String visibility;

  final FirebaseDataConnect _dataConnect;
  SetMyResumeVariablesBuilder(this._dataConnect, {required  this.url,required  this.fileName,required  this.visibility,});
  Deserializer<SetMyResumeData> dataDeserializer = (dynamic json)  => SetMyResumeData.fromJson(jsonDecode(json));
  Serializer<SetMyResumeVariables> varsSerializer = (SetMyResumeVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SetMyResumeData, SetMyResumeVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SetMyResumeData, SetMyResumeVariables> ref() {
    SetMyResumeVariables vars= SetMyResumeVariables(url: url,fileName: fileName,visibility: visibility,);
    return _dataConnect.mutation("SetMyResume", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SetMyResumeUserUpdate {
  final String uid;
  SetMyResumeUserUpdate.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMyResumeUserUpdate otherTyped = other as SetMyResumeUserUpdate;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  SetMyResumeUserUpdate({
    required this.uid,
  });
}

@immutable
class SetMyResumeData {
  final SetMyResumeUserUpdate? user_update;
  SetMyResumeData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : SetMyResumeUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMyResumeData otherTyped = other as SetMyResumeData;
    return user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => user_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  SetMyResumeData({
    this.user_update,
  });
}

@immutable
class SetMyResumeVariables {
  final String url;
  final String fileName;
  final String visibility;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SetMyResumeVariables.fromJson(Map<String, dynamic> json):
  
  url = nativeFromJson<String>(json['url']),
  fileName = nativeFromJson<String>(json['fileName']),
  visibility = nativeFromJson<String>(json['visibility']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMyResumeVariables otherTyped = other as SetMyResumeVariables;
    return url == otherTyped.url && 
    fileName == otherTyped.fileName && 
    visibility == otherTyped.visibility;
    
  }
  @override
  int get hashCode => Object.hashAll([url.hashCode, fileName.hashCode, visibility.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['url'] = nativeToJson<String>(url);
    json['fileName'] = nativeToJson<String>(fileName);
    json['visibility'] = nativeToJson<String>(visibility);
    return json;
  }

  SetMyResumeVariables({
    required this.url,
    required this.fileName,
    required this.visibility,
  });
}

