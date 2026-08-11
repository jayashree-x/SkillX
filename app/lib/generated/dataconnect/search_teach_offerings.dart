part of 'default.dart';

class SearchTeachOfferingsVariablesBuilder {
  String q;

  final FirebaseDataConnect _dataConnect;
  SearchTeachOfferingsVariablesBuilder(this._dataConnect, {required  this.q,});
  Deserializer<SearchTeachOfferingsData> dataDeserializer = (dynamic json)  => SearchTeachOfferingsData.fromJson(jsonDecode(json));
  Serializer<SearchTeachOfferingsVariables> varsSerializer = (SearchTeachOfferingsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchTeachOfferingsData, SearchTeachOfferingsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<SearchTeachOfferingsData, SearchTeachOfferingsVariables> ref() {
    SearchTeachOfferingsVariables vars= SearchTeachOfferingsVariables(q: q,);
    return _dataConnect.query("SearchTeachOfferings", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SearchTeachOfferingsUserSkills {
  final String? proficiency;
  final SearchTeachOfferingsUserSkillsSkill skill;
  final SearchTeachOfferingsUserSkillsUser user;
  SearchTeachOfferingsUserSkills.fromJson(dynamic json):
  
  proficiency = json['proficiency'] == null ? null : nativeFromJson<String>(json['proficiency']),
  skill = SearchTeachOfferingsUserSkillsSkill.fromJson(json['skill']),
  user = SearchTeachOfferingsUserSkillsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchTeachOfferingsUserSkills otherTyped = other as SearchTeachOfferingsUserSkills;
    return proficiency == otherTyped.proficiency && 
    skill == otherTyped.skill && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([proficiency.hashCode, skill.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (proficiency != null) {
      json['proficiency'] = nativeToJson<String?>(proficiency);
    }
    json['skill'] = skill.toJson();
    json['user'] = user.toJson();
    return json;
  }

  SearchTeachOfferingsUserSkills({
    this.proficiency,
    required this.skill,
    required this.user,
  });
}

@immutable
class SearchTeachOfferingsUserSkillsSkill {
  final String id;
  final String name;
  final String category;
  final String? description;
  SearchTeachOfferingsUserSkillsSkill.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  category = nativeFromJson<String>(json['category']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchTeachOfferingsUserSkillsSkill otherTyped = other as SearchTeachOfferingsUserSkillsSkill;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    category == otherTyped.category && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, category.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['category'] = nativeToJson<String>(category);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  SearchTeachOfferingsUserSkillsSkill({
    required this.id,
    required this.name,
    required this.category,
    this.description,
  });
}

@immutable
class SearchTeachOfferingsUserSkillsUser {
  final String uid;
  final String name;
  final String? photoUrl;
  final double averageRating;
  final int totalSessions;
  SearchTeachOfferingsUserSkillsUser.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']),
  name = nativeFromJson<String>(json['name']),
  photoUrl = json['photoUrl'] == null ? null : nativeFromJson<String>(json['photoUrl']),
  averageRating = nativeFromJson<double>(json['averageRating']),
  totalSessions = nativeFromJson<int>(json['totalSessions']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchTeachOfferingsUserSkillsUser otherTyped = other as SearchTeachOfferingsUserSkillsUser;
    return uid == otherTyped.uid && 
    name == otherTyped.name && 
    photoUrl == otherTyped.photoUrl && 
    averageRating == otherTyped.averageRating && 
    totalSessions == otherTyped.totalSessions;
    
  }
  @override
  int get hashCode => Object.hashAll([uid.hashCode, name.hashCode, photoUrl.hashCode, averageRating.hashCode, totalSessions.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    json['name'] = nativeToJson<String>(name);
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['averageRating'] = nativeToJson<double>(averageRating);
    json['totalSessions'] = nativeToJson<int>(totalSessions);
    return json;
  }

  SearchTeachOfferingsUserSkillsUser({
    required this.uid,
    required this.name,
    this.photoUrl,
    required this.averageRating,
    required this.totalSessions,
  });
}

@immutable
class SearchTeachOfferingsData {
  final List<SearchTeachOfferingsUserSkills> userSkills;
  SearchTeachOfferingsData.fromJson(dynamic json):
  
  userSkills = (json['userSkills'] as List<dynamic>)
        .map((e) => SearchTeachOfferingsUserSkills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchTeachOfferingsData otherTyped = other as SearchTeachOfferingsData;
    return userSkills == otherTyped.userSkills;
    
  }
  @override
  int get hashCode => userSkills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userSkills'] = userSkills.map((e) => e.toJson()).toList();
    return json;
  }

  SearchTeachOfferingsData({
    required this.userSkills,
  });
}

@immutable
class SearchTeachOfferingsVariables {
  final String q;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SearchTeachOfferingsVariables.fromJson(Map<String, dynamic> json):
  
  q = nativeFromJson<String>(json['q']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchTeachOfferingsVariables otherTyped = other as SearchTeachOfferingsVariables;
    return q == otherTyped.q;
    
  }
  @override
  int get hashCode => q.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['q'] = nativeToJson<String>(q);
    return json;
  }

  SearchTeachOfferingsVariables({
    required this.q,
  });
}

