part of 'default.dart';

class SetMyFcmTokenVariablesBuilder {
  String token;

  final FirebaseDataConnect _dataConnect;
  SetMyFcmTokenVariablesBuilder(this._dataConnect, {required  this.token,});
  Deserializer<SetMyFcmTokenData> dataDeserializer = (dynamic json)  => SetMyFcmTokenData.fromJson(jsonDecode(json));
  Serializer<SetMyFcmTokenVariables> varsSerializer = (SetMyFcmTokenVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SetMyFcmTokenData, SetMyFcmTokenVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SetMyFcmTokenData, SetMyFcmTokenVariables> ref() {
    SetMyFcmTokenVariables vars= SetMyFcmTokenVariables(token: token,);
    return _dataConnect.mutation("SetMyFcmToken", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SetMyFcmTokenUserUpdate {
  final String uid;
  SetMyFcmTokenUserUpdate.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMyFcmTokenUserUpdate otherTyped = other as SetMyFcmTokenUserUpdate;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  SetMyFcmTokenUserUpdate({
    required this.uid,
  });
}

@immutable
class SetMyFcmTokenData {
  final SetMyFcmTokenUserUpdate? user_update;
  SetMyFcmTokenData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : SetMyFcmTokenUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMyFcmTokenData otherTyped = other as SetMyFcmTokenData;
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

  SetMyFcmTokenData({
    this.user_update,
  });
}

@immutable
class SetMyFcmTokenVariables {
  final String token;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SetMyFcmTokenVariables.fromJson(Map<String, dynamic> json):
  
  token = nativeFromJson<String>(json['token']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetMyFcmTokenVariables otherTyped = other as SetMyFcmTokenVariables;
    return token == otherTyped.token;
    
  }
  @override
  int get hashCode => token.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    return json;
  }

  SetMyFcmTokenVariables({
    required this.token,
  });
}

