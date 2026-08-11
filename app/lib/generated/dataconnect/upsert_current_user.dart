part of 'default.dart';

class UpsertCurrentUserVariablesBuilder {
  String name;
  String email;
  Optional<String> _photoUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertCurrentUserVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  UpsertCurrentUserVariablesBuilder(this._dataConnect, {required  this.name,required  this.email,});
  Deserializer<UpsertCurrentUserData> dataDeserializer = (dynamic json)  => UpsertCurrentUserData.fromJson(jsonDecode(json));
  Serializer<UpsertCurrentUserVariables> varsSerializer = (UpsertCurrentUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCurrentUserData, UpsertCurrentUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCurrentUserData, UpsertCurrentUserVariables> ref() {
    UpsertCurrentUserVariables vars= UpsertCurrentUserVariables(name: name,email: email,photoUrl: _photoUrl,);
    return _dataConnect.mutation("UpsertCurrentUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCurrentUserUserUpsert {
  final String uid;
  UpsertCurrentUserUserUpsert.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCurrentUserUserUpsert otherTyped = other as UpsertCurrentUserUserUpsert;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  UpsertCurrentUserUserUpsert({
    required this.uid,
  });
}

@immutable
class UpsertCurrentUserData {
  final UpsertCurrentUserUserUpsert user_upsert;
  UpsertCurrentUserData.fromJson(dynamic json):
  
  user_upsert = UpsertCurrentUserUserUpsert.fromJson(json['user_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCurrentUserData otherTyped = other as UpsertCurrentUserData;
    return user_upsert == otherTyped.user_upsert;
    
  }
  @override
  int get hashCode => user_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_upsert'] = user_upsert.toJson();
    return json;
  }

  UpsertCurrentUserData({
    required this.user_upsert,
  });
}

@immutable
class UpsertCurrentUserVariables {
  final String name;
  final String email;
  late final Optional<String>photoUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCurrentUserVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']),
  email = nativeFromJson<String>(json['email']) {
  
  
  
  
    photoUrl = Optional.optional(nativeFromJson, nativeToJson);
    photoUrl.value = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCurrentUserVariables otherTyped = other as UpsertCurrentUserVariables;
    return name == otherTyped.name && 
    email == otherTyped.email && 
    photoUrl == otherTyped.photoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, email.hashCode, photoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['email'] = nativeToJson<String>(email);
    if(photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    return json;
  }

  UpsertCurrentUserVariables({
    required this.name,
    required this.email,
    required this.photoUrl,
  });
}

