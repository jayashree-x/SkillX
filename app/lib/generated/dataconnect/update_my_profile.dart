part of 'default.dart';

class UpdateMyProfileVariablesBuilder {
  Optional<String> _name = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _bio = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _photoUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdateMyProfileVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateMyProfileVariablesBuilder bio(String? t) {
   _bio.value = t;
   return this;
  }
  UpdateMyProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  UpdateMyProfileVariablesBuilder(this._dataConnect, );
  Deserializer<UpdateMyProfileData> dataDeserializer = (dynamic json)  => UpdateMyProfileData.fromJson(jsonDecode(json));
  Serializer<UpdateMyProfileVariables> varsSerializer = (UpdateMyProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMyProfileData, UpdateMyProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateMyProfileData, UpdateMyProfileVariables> ref() {
    UpdateMyProfileVariables vars= UpdateMyProfileVariables(name: _name,bio: _bio,photoUrl: _photoUrl,);
    return _dataConnect.mutation("UpdateMyProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateMyProfileUserUpdate {
  final String uid;
  UpdateMyProfileUserUpdate.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMyProfileUserUpdate otherTyped = other as UpdateMyProfileUserUpdate;
    return uid == otherTyped.uid;
    
  }
  @override
  int get hashCode => uid.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    return json;
  }

  UpdateMyProfileUserUpdate({
    required this.uid,
  });
}

@immutable
class UpdateMyProfileData {
  final UpdateMyProfileUserUpdate? user_update;
  UpdateMyProfileData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : UpdateMyProfileUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMyProfileData otherTyped = other as UpdateMyProfileData;
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

  UpdateMyProfileData({
    this.user_update,
  });
}

@immutable
class UpdateMyProfileVariables {
  late final Optional<String>name;
  late final Optional<String>bio;
  late final Optional<String>photoUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateMyProfileVariables.fromJson(Map<String, dynamic> json) {
  
  
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  
  
    bio = Optional.optional(nativeFromJson, nativeToJson);
    bio.value = json['bio'] == null ? null : nativeFromJson<String>(json['bio']);
  
  
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

    final UpdateMyProfileVariables otherTyped = other as UpdateMyProfileVariables;
    return name == otherTyped.name && 
    bio == otherTyped.bio && 
    photoUrl == otherTyped.photoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, bio.hashCode, photoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    if(bio.state == OptionalState.set) {
      json['bio'] = bio.toJson();
    }
    if(photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    return json;
  }

  UpdateMyProfileVariables({
    required this.name,
    required this.bio,
    required this.photoUrl,
  });
}

