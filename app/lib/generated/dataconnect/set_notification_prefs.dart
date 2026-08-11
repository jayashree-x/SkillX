part of 'default.dart';

class SetNotificationPrefsVariablesBuilder {
  AnyValue prefs;

  final FirebaseDataConnect _dataConnect;
  SetNotificationPrefsVariablesBuilder(this._dataConnect, {required  this.prefs,});
  Deserializer<SetNotificationPrefsData> dataDeserializer = (dynamic json)  => SetNotificationPrefsData.fromJson(jsonDecode(json));
  Serializer<SetNotificationPrefsVariables> varsSerializer = (SetNotificationPrefsVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SetNotificationPrefsData, SetNotificationPrefsVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SetNotificationPrefsData, SetNotificationPrefsVariables> ref() {
    SetNotificationPrefsVariables vars= SetNotificationPrefsVariables(prefs: prefs,);
    return _dataConnect.mutation("SetNotificationPrefs", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SetNotificationPrefsUserUpdate {
  final String uid;
  SetNotificationPrefsUserUpdate.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetNotificationPrefsUserUpdate otherTyped = other as SetNotificationPrefsUserUpdate;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  SetNotificationPrefsUserUpdate({
    required this.uid,
  });
}

@immutable
class SetNotificationPrefsData {
  final SetNotificationPrefsUserUpdate? user_update;
  SetNotificationPrefsData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : SetNotificationPrefsUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetNotificationPrefsData otherTyped = other as SetNotificationPrefsData;
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

  SetNotificationPrefsData({
    this.user_update,
  });
}

@immutable
class SetNotificationPrefsVariables {
  final AnyValue prefs;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SetNotificationPrefsVariables.fromJson(Map<String, dynamic> json):
  
  prefs = AnyValue.fromJson(json['prefs']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SetNotificationPrefsVariables otherTyped = other as SetNotificationPrefsVariables;
    return prefs == otherTyped.prefs;
    
  }
  @override
  int get hashCode => prefs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prefs'] = prefs.toJson();
    return json;
  }

  SetNotificationPrefsVariables({
    required this.prefs,
  });
}

