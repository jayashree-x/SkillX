part of 'default.dart';

class GetLearnerQuizVariablesBuilder {
  String quizId;

  final FirebaseDataConnect _dataConnect;
  GetLearnerQuizVariablesBuilder(this._dataConnect, {required  this.quizId,});
  Deserializer<GetLearnerQuizData> dataDeserializer = (dynamic json)  => GetLearnerQuizData.fromJson(jsonDecode(json));
  Serializer<GetLearnerQuizVariables> varsSerializer = (GetLearnerQuizVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetLearnerQuizData, GetLearnerQuizVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetLearnerQuizData, GetLearnerQuizVariables> ref() {
    GetLearnerQuizVariables vars= GetLearnerQuizVariables(quizId: quizId,);
    return _dataConnect.query("GetLearnerQuiz", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetLearnerQuizQuiz {
  final String id;
  final String topic;
  final List<String>? coveredSubtopics;
  final EnumValue<SessionLevel> level;
  final bool isApproved;
  final List<GetLearnerQuizQuizQuestions> questions;
  GetLearnerQuizQuiz.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  topic = nativeFromJson<String>(json['topic']),
  coveredSubtopics = json['coveredSubtopics'] == null ? null : (json['coveredSubtopics'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList(),
  level = sessionLevelDeserializer(json['level']),
  isApproved = nativeFromJson<bool>(json['isApproved']),
  questions = (json['questions'] as List<dynamic>)
        .map((e) => GetLearnerQuizQuizQuestions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLearnerQuizQuiz otherTyped = other as GetLearnerQuizQuiz;
    return id == otherTyped.id && 
    topic == otherTyped.topic && 
    coveredSubtopics == otherTyped.coveredSubtopics && 
    level == otherTyped.level && 
    isApproved == otherTyped.isApproved && 
    questions == otherTyped.questions;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, topic.hashCode, coveredSubtopics.hashCode, level.hashCode, isApproved.hashCode, questions.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['topic'] = nativeToJson<String>(topic);
    if (coveredSubtopics != null) {
      json['coveredSubtopics'] = coveredSubtopics?.map((e) => nativeToJson<String>(e)).toList();
    }
    json['level'] = 
    sessionLevelSerializer(level)
    ;
    json['isApproved'] = nativeToJson<bool>(isApproved);
    json['questions'] = questions.map((e) => e.toJson()).toList();
    return json;
  }

  GetLearnerQuizQuiz({
    required this.id,
    required this.topic,
    this.coveredSubtopics,
    required this.level,
    required this.isApproved,
    required this.questions,
  });
}

@immutable
class GetLearnerQuizQuizQuestions {
  final String id;
  final int order;
  final String questionText;
  final String option0;
  final String option1;
  final String option2;
  final String option3;
  GetLearnerQuizQuizQuestions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  order = nativeFromJson<int>(json['order']),
  questionText = nativeFromJson<String>(json['questionText']),
  option0 = nativeFromJson<String>(json['option0']),
  option1 = nativeFromJson<String>(json['option1']),
  option2 = nativeFromJson<String>(json['option2']),
  option3 = nativeFromJson<String>(json['option3']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLearnerQuizQuizQuestions otherTyped = other as GetLearnerQuizQuizQuestions;
    return id == otherTyped.id && 
    order == otherTyped.order && 
    questionText == otherTyped.questionText && 
    option0 == otherTyped.option0 && 
    option1 == otherTyped.option1 && 
    option2 == otherTyped.option2 && 
    option3 == otherTyped.option3;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, order.hashCode, questionText.hashCode, option0.hashCode, option1.hashCode, option2.hashCode, option3.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['order'] = nativeToJson<int>(order);
    json['questionText'] = nativeToJson<String>(questionText);
    json['option0'] = nativeToJson<String>(option0);
    json['option1'] = nativeToJson<String>(option1);
    json['option2'] = nativeToJson<String>(option2);
    json['option3'] = nativeToJson<String>(option3);
    return json;
  }

  GetLearnerQuizQuizQuestions({
    required this.id,
    required this.order,
    required this.questionText,
    required this.option0,
    required this.option1,
    required this.option2,
    required this.option3,
  });
}

@immutable
class GetLearnerQuizData {
  final GetLearnerQuizQuiz? quiz;
  GetLearnerQuizData.fromJson(dynamic json):
  
  quiz = json['quiz'] == null ? null : GetLearnerQuizQuiz.fromJson(json['quiz']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLearnerQuizData otherTyped = other as GetLearnerQuizData;
    return quiz == otherTyped.quiz;
    
  }
  @override
  int get hashCode => quiz.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (quiz != null) {
      json['quiz'] = quiz!.toJson();
    }
    return json;
  }

  GetLearnerQuizData({
    this.quiz,
  });
}

@immutable
class GetLearnerQuizVariables {
  final String quizId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetLearnerQuizVariables.fromJson(Map<String, dynamic> json):
  
  quizId = nativeFromJson<String>(json['quizId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetLearnerQuizVariables otherTyped = other as GetLearnerQuizVariables;
    return quizId == otherTyped.quizId;
    
  }
  @override
  int get hashCode => quizId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['quizId'] = nativeToJson<String>(quizId);
    return json;
  }

  GetLearnerQuizVariables({
    required this.quizId,
  });
}

