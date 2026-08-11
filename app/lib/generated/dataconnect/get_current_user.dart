part of 'default.dart';

class GetCurrentUserVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetCurrentUserVariablesBuilder(this._dataConnect, );
  Deserializer<GetCurrentUserData> dataDeserializer = (dynamic json)  => GetCurrentUserData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetCurrentUserData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetCurrentUserData, void> ref() {
    
    return _dataConnect.query("GetCurrentUser", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetCurrentUserUsers {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final String? authProvider;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final int totalSessions;
  final double averageRating;
  final String? resumeUrl;
  final String? resumeFileName;
  final Timestamp? resumeUploadedAt;
  final String resumeVisibility;
  GetCurrentUserUsers.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']),
  name = nativeFromJson<String>(json['name']),
  email = nativeFromJson<String>(json['email']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  bio = json['bio'] == null ? null : nativeFromJson<String>(json['bio']),
  authProvider = json['authProvider'] == null ? null : nativeFromJson<String>(json['authProvider']),
  currentStreak = nativeFromJson<int>(json['currentStreak']),
  longestStreak = nativeFromJson<int>(json['longestStreak']),
  lastActivityDate = json['lastActivityDate'] == null ? null : nativeFromJson<DateTime>(json['lastActivityDate']),
  totalSessions = nativeFromJson<int>(json['totalSessions']),
  averageRating = nativeFromJson<double>(json['averageRating']),
  resumeUrl = json['resumeUrl'] == null ? null : nativeFromJson<String>(json['resumeUrl']),
  resumeFileName = json['resumeFileName'] == null ? null : nativeFromJson<String>(json['resumeFileName']),
  resumeUploadedAt = json['resumeUploadedAt'] == null ? null : Timestamp.fromJson(json['resumeUploadedAt']),
  resumeVisibility = nativeFromJson<String>(json['resumeVisibility']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCurrentUserUsers otherTyped = other as GetCurrentUserUsers;
    return uid == otherTyped.uid && 
    name == otherTyped.name && 
    email == otherTyped.email && 
    photoUrl == otherTyped.photoUrl && 
    bio == otherTyped.bio && 
    authProvider == otherTyped.authProvider && 
    currentStreak == otherTyped.currentStreak && 
    longestStreak == otherTyped.longestStreak && 
    lastActivityDate == otherTyped.lastActivityDate && 
    totalSessions == otherTyped.totalSessions && 
    averageRating == otherTyped.averageRating && 
    resumeUrl == otherTyped.resumeUrl && 
    resumeFileName == otherTyped.resumeFileName && 
    resumeUploadedAt == otherTyped.resumeUploadedAt && 
    resumeVisibility == otherTyped.resumeVisibility;
    
  }
  @override
  int get hashCode => Object.hashAll([uid.hashCode, name.hashCode, email.hashCode, photoUrl.hashCode, bio.hashCode, authProvider.hashCode, currentStreak.hashCode, longestStreak.hashCode, lastActivityDate.hashCode, totalSessions.hashCode, averageRating.hashCode, resumeUrl.hashCode, resumeFileName.hashCode, resumeUploadedAt.hashCode, resumeVisibility.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    json['name'] = nativeToJson<String>(name);
    json['email'] = nativeToJson<String>(email);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    if (bio != null) {
      json['bio'] = nativeToJson<String?>(bio);
    }
    if (authProvider != null) {
      json['authProvider'] = nativeToJson<String?>(authProvider);
    }
    json['currentStreak'] = nativeToJson<int>(currentStreak);
    json['longestStreak'] = nativeToJson<int>(longestStreak);
    if (lastActivityDate != null) {
      json['lastActivityDate'] = nativeToJson<DateTime?>(lastActivityDate);
    }
    json['totalSessions'] = nativeToJson<int>(totalSessions);
    json['averageRating'] = nativeToJson<double>(averageRating);
    if (resumeUrl != null) {
      json['resumeUrl'] = nativeToJson<String?>(resumeUrl);
    }
    if (resumeFileName != null) {
      json['resumeFileName'] = nativeToJson<String?>(resumeFileName);
    }
    if (resumeUploadedAt != null) {
      json['resumeUploadedAt'] = resumeUploadedAt!.toJson();
    }
    json['resumeVisibility'] = nativeToJson<String>(resumeVisibility);
    return json;
  }

  GetCurrentUserUsers({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    this.authProvider,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    required this.totalSessions,
    required this.averageRating,
    this.resumeUrl,
    this.resumeFileName,
    this.resumeUploadedAt,
    required this.resumeVisibility,
  });
}

@immutable
class GetCurrentUserData {
  final List<GetCurrentUserUsers> users;
  GetCurrentUserData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => GetCurrentUserUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCurrentUserData otherTyped = other as GetCurrentUserData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  GetCurrentUserData({
    required this.users,
  });
}

