part of 'default.dart';

class DeleteMyResumeVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  DeleteMyResumeVariablesBuilder(this._dataConnect, );
  Deserializer<DeleteMyResumeData> dataDeserializer = (dynamic json)  => DeleteMyResumeData.fromJson(jsonDecode(json));
  
  Future<OperationResult<DeleteMyResumeData, void>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteMyResumeData, void> ref() {
    
    return _dataConnect.mutation("DeleteMyResume", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class DeleteMyResumeUserUpdate {
  final String uid;
  DeleteMyResumeUserUpdate.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMyResumeUserUpdate otherTyped = other as DeleteMyResumeUserUpdate;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  DeleteMyResumeUserUpdate({
    required this.uid,
  });
}

@immutable
class DeleteMyResumeData {
  final DeleteMyResumeUserUpdate? user_update;
  DeleteMyResumeData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : DeleteMyResumeUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMyResumeData otherTyped = other as DeleteMyResumeData;
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

  DeleteMyResumeData({
    this.user_update,
  });
}

