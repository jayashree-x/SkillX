part of 'default.dart';

class GetMyNotificationPrefsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyNotificationPrefsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyNotificationPrefsData> dataDeserializer = (dynamic json)  => GetMyNotificationPrefsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyNotificationPrefsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyNotificationPrefsData, void> ref() {
    
    return _dataConnect.query("GetMyNotificationPrefs", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyNotificationPrefsUsers {
  final AnyValue? notificationPrefs;
  GetMyNotificationPrefsUsers.fromJson(dynamic json):
  
  notificationPrefs = json['notificationPrefs'] == null ? null : AnyValue.fromJson(json['notificationPrefs']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyNotificationPrefsUsers otherTyped = other as GetMyNotificationPrefsUsers;
    return notificationPrefs == otherTyped.notificationPrefs;
    
  }
  @override
  int get hashCode => notificationPrefs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (notificationPrefs != null) {
      json['notificationPrefs'] = notificationPrefs!.toJson();
    }
    return json;
  }

  GetMyNotificationPrefsUsers({
    this.notificationPrefs,
  });
}

@immutable
class GetMyNotificationPrefsData {
  final List<GetMyNotificationPrefsUsers> users;
  GetMyNotificationPrefsData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => GetMyNotificationPrefsUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyNotificationPrefsData otherTyped = other as GetMyNotificationPrefsData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyNotificationPrefsData({
    required this.users,
  });
}

