part of 'default.dart';

class GetMyCertificatesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyCertificatesVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyCertificatesData> dataDeserializer = (dynamic json)  => GetMyCertificatesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyCertificatesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyCertificatesData, void> ref() {
    
    return _dataConnect.query("GetMyCertificates", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyCertificatesCertificates {
  final String id;
  final String skillName;
  final String teacherName;
  final double averageScore;
  final int modulesCompleted;
  final String? pdfUrl;
  final Timestamp issuedAt;
  GetMyCertificatesCertificates.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  skillName = nativeFromJson<String>(json['skillName']),
  teacherName = nativeFromJson<String>(json['teacherName']),
  averageScore = nativeFromJson<double>(json['averageScore']),
  modulesCompleted = nativeFromJson<int>(json['modulesCompleted']),
  pdfUrl = json['pdfUrl'] == null ? null : nativeFromJson<String>(json['pdfUrl']),
  issuedAt = Timestamp.fromJson(json['issuedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyCertificatesCertificates otherTyped = other as GetMyCertificatesCertificates;
    return id == otherTyped.id && 
    skillName == otherTyped.skillName && 
    teacherName == otherTyped.teacherName && 
    averageScore == otherTyped.averageScore && 
    modulesCompleted == otherTyped.modulesCompleted && 
    pdfUrl == otherTyped.pdfUrl && 
    issuedAt == otherTyped.issuedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, skillName.hashCode, teacherName.hashCode, averageScore.hashCode, modulesCompleted.hashCode, pdfUrl.hashCode, issuedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['skillName'] = nativeToJson<String>(skillName);
    json['teacherName'] = nativeToJson<String>(teacherName);
    json['averageScore'] = nativeToJson<double>(averageScore);
    json['modulesCompleted'] = nativeToJson<int>(modulesCompleted);
    if (pdfUrl != null) {
      json['pdfUrl'] = nativeToJson<String?>(pdfUrl);
    }
    json['issuedAt'] = issuedAt.toJson();
    return json;
  }

  GetMyCertificatesCertificates({
    required this.id,
    required this.skillName,
    required this.teacherName,
    required this.averageScore,
    required this.modulesCompleted,
    this.pdfUrl,
    required this.issuedAt,
  });
}

@immutable
class GetMyCertificatesData {
  final List<GetMyCertificatesCertificates> certificates;
  GetMyCertificatesData.fromJson(dynamic json):
  
  certificates = (json['certificates'] as List<dynamic>)
        .map((e) => GetMyCertificatesCertificates.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyCertificatesData otherTyped = other as GetMyCertificatesData;
    return certificates == otherTyped.certificates;
    
  }
  @override
  int get hashCode => certificates.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['certificates'] = certificates.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyCertificatesData({
    required this.certificates,
  });
}

