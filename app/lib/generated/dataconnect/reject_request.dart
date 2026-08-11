part of 'default.dart';

class RejectRequestVariablesBuilder {
  String requestId;

  final FirebaseDataConnect _dataConnect;
  RejectRequestVariablesBuilder(this._dataConnect, {required  this.requestId,});
  Deserializer<RejectRequestData> dataDeserializer = (dynamic json)  => RejectRequestData.fromJson(jsonDecode(json));
  Serializer<RejectRequestVariables> varsSerializer = (RejectRequestVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RejectRequestData, RejectRequestVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RejectRequestData, RejectRequestVariables> ref() {
    RejectRequestVariables vars= RejectRequestVariables(requestId: requestId,);
    return _dataConnect.mutation("RejectRequest", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RejectRequestData {
  final int request_updateMany;
  RejectRequestData.fromJson(dynamic json):
  
  request_updateMany = nativeFromJson<int>(json['request_updateMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RejectRequestData otherTyped = other as RejectRequestData;
    return request_updateMany == otherTyped.request_updateMany;
    
  }
  @override
  int get hashCode => request_updateMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['request_updateMany'] = nativeToJson<int>(request_updateMany);
    return json;
  }

  RejectRequestData({
    required this.request_updateMany,
  });
}

@immutable
class RejectRequestVariables {
  final String requestId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RejectRequestVariables.fromJson(Map<String, dynamic> json):
  
  requestId = nativeFromJson<String>(json['requestId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RejectRequestVariables otherTyped = other as RejectRequestVariables;
    return requestId == otherTyped.requestId;
    
  }
  @override
  int get hashCode => requestId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['requestId'] = nativeToJson<String>(requestId);
    return json;
  }

  RejectRequestVariables({
    required this.requestId,
  });
}

