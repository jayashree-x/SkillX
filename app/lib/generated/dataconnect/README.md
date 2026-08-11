# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
DefaultConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetCurrentUser
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getCurrentUser().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCurrentUserData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getCurrentUser();
GetCurrentUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getCurrentUser().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyNotificationPrefs
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyNotificationPrefs().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyNotificationPrefsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyNotificationPrefs();
GetMyNotificationPrefsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyNotificationPrefs().ref();
ref.execute();

ref.subscribe(...);
```


### GetMySkills
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMySkills().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMySkillsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMySkills();
GetMySkillsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMySkills().ref();
ref.execute();

ref.subscribe(...);
```


### SearchSkills
#### Required Arguments
```dart
String q = ...;
DefaultConnector.instance.searchSkills(
  q: q,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SearchSkillsData, SearchSkillsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.searchSkills(
  q: q,
);
SearchSkillsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String q = ...;

final ref = DefaultConnector.instance.searchSkills(
  q: q,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListSkillsByCategory
#### Required Arguments
```dart
String category = ...;
DefaultConnector.instance.listSkillsByCategory(
  category: category,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListSkillsByCategoryData, ListSkillsByCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listSkillsByCategory(
  category: category,
);
ListSkillsByCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String category = ...;

final ref = DefaultConnector.instance.listSkillsByCategory(
  category: category,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListSkills
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.listSkills().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListSkillsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listSkills();
ListSkillsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.listSkills().ref();
ref.execute();

ref.subscribe(...);
```


### ListTeachersForSkill
#### Required Arguments
```dart
String skillId = ...;
DefaultConnector.instance.listTeachersForSkill(
  skillId: skillId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListTeachersForSkillData, ListTeachersForSkillVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listTeachersForSkill(
  skillId: skillId,
);
ListTeachersForSkillData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String skillId = ...;

final ref = DefaultConnector.instance.listTeachersForSkill(
  skillId: skillId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListTeachOfferings
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.listTeachOfferings().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListTeachOfferingsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listTeachOfferings();
ListTeachOfferingsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.listTeachOfferings().ref();
ref.execute();

ref.subscribe(...);
```


### SearchTeachOfferings
#### Required Arguments
```dart
String q = ...;
DefaultConnector.instance.searchTeachOfferings(
  q: q,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SearchTeachOfferingsData, SearchTeachOfferingsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.searchTeachOfferings(
  q: q,
);
SearchTeachOfferingsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String q = ...;

final ref = DefaultConnector.instance.searchTeachOfferings(
  q: q,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetIncomingRequests
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getIncomingRequests().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetIncomingRequestsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getIncomingRequests();
GetIncomingRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getIncomingRequests().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyAcceptedTeachingRequests
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyAcceptedTeachingRequests().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyAcceptedTeachingRequestsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyAcceptedTeachingRequests();
GetMyAcceptedTeachingRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyAcceptedTeachingRequests().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyOutgoingRequests
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyOutgoingRequests().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyOutgoingRequestsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyOutgoingRequests();
GetMyOutgoingRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyOutgoingRequests().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyUpcomingSessionsAsLearner
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyUpcomingSessionsAsLearner().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyUpcomingSessionsAsLearnerData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyUpcomingSessionsAsLearner();
GetMyUpcomingSessionsAsLearnerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyUpcomingSessionsAsLearner().ref();
ref.execute();

ref.subscribe(...);
```


### GetSession
#### Required Arguments
```dart
String sessionId = ...;
DefaultConnector.instance.getSession(
  sessionId: sessionId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetSessionData, GetSessionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getSession(
  sessionId: sessionId,
);
GetSessionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String sessionId = ...;

final ref = DefaultConnector.instance.getSession(
  sessionId: sessionId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyTeachingSessions
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyTeachingSessions().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyTeachingSessionsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyTeachingSessions();
GetMyTeachingSessionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyTeachingSessions().ref();
ref.execute();

ref.subscribe(...);
```


### GetMyQuizzes
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyQuizzes().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyQuizzesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyQuizzes();
GetMyQuizzesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyQuizzes().ref();
ref.execute();

ref.subscribe(...);
```


### GetLearnerQuiz
#### Required Arguments
```dart
String quizId = ...;
DefaultConnector.instance.getLearnerQuiz(
  quizId: quizId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetLearnerQuizData, GetLearnerQuizVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getLearnerQuiz(
  quizId: quizId,
);
GetLearnerQuizData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String quizId = ...;

final ref = DefaultConnector.instance.getLearnerQuiz(
  quizId: quizId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyAttempts
#### Required Arguments
```dart
int limit = ...;
DefaultConnector.instance.getMyAttempts(
  limit: limit,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyAttemptsData, GetMyAttemptsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyAttempts(
  limit: limit,
);
GetMyAttemptsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
int limit = ...;

final ref = DefaultConnector.instance.getMyAttempts(
  limit: limit,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyProgress
#### Required Arguments
```dart
String pathId = ...;
DefaultConnector.instance.getMyProgress(
  pathId: pathId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyProgressData, GetMyProgressVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyProgress(
  pathId: pathId,
);
GetMyProgressData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String pathId = ...;

final ref = DefaultConnector.instance.getMyProgress(
  pathId: pathId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyLearningPaths
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyLearningPaths().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyLearningPathsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyLearningPaths();
GetMyLearningPathsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyLearningPaths().ref();
ref.execute();

ref.subscribe(...);
```


### ListLearningPaths
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.listLearningPaths().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListLearningPathsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listLearningPaths();
ListLearningPathsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.listLearningPaths().ref();
ref.execute();

ref.subscribe(...);
```


### GetPathDetail
#### Required Arguments
```dart
String pathId = ...;
DefaultConnector.instance.getPathDetail(
  pathId: pathId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPathDetailData, GetPathDetailVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getPathDetail(
  pathId: pathId,
);
GetPathDetailData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String pathId = ...;

final ref = DefaultConnector.instance.getPathDetail(
  pathId: pathId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetModuleQuiz
#### Required Arguments
```dart
String moduleId = ...;
DefaultConnector.instance.getModuleQuiz(
  moduleId: moduleId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetModuleQuizData, GetModuleQuizVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getModuleQuiz(
  moduleId: moduleId,
);
GetModuleQuizData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String moduleId = ...;

final ref = DefaultConnector.instance.getModuleQuiz(
  moduleId: moduleId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyCertificates
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.getMyCertificates().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyCertificatesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getMyCertificates();
GetMyCertificatesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.getMyCertificates().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpsertCurrentUser
#### Required Arguments
```dart
String name = ...;
String email = ...;
DefaultConnector.instance.upsertCurrentUser(
  name: name,
  email: email,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCurrentUser, we created `UpsertCurrentUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCurrentUserVariablesBuilder {
  ...
   UpsertCurrentUserVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  ...
}
DefaultConnector.instance.upsertCurrentUser(
  name: name,
  email: email,
)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCurrentUserData, UpsertCurrentUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.upsertCurrentUser(
  name: name,
  email: email,
);
UpsertCurrentUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
String email = ...;

final ref = DefaultConnector.instance.upsertCurrentUser(
  name: name,
  email: email,
).ref();
ref.execute();
```


### UpdateMyProfile
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.updateMyProfile().execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateMyProfile, we created `UpdateMyProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateMyProfileVariablesBuilder {
  ...
 
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

  ...
}
DefaultConnector.instance.updateMyProfile()
.name(name)
.bio(bio)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateMyProfileData, UpdateMyProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.updateMyProfile();
UpdateMyProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.updateMyProfile().ref();
ref.execute();
```


### SetMyResume
#### Required Arguments
```dart
String url = ...;
String fileName = ...;
String visibility = ...;
DefaultConnector.instance.setMyResume(
  url: url,
  fileName: fileName,
  visibility: visibility,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SetMyResumeData, SetMyResumeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.setMyResume(
  url: url,
  fileName: fileName,
  visibility: visibility,
);
SetMyResumeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String url = ...;
String fileName = ...;
String visibility = ...;

final ref = DefaultConnector.instance.setMyResume(
  url: url,
  fileName: fileName,
  visibility: visibility,
).ref();
ref.execute();
```


### DeleteMyResume
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.deleteMyResume().execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteMyResumeData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.deleteMyResume();
DeleteMyResumeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.deleteMyResume().ref();
ref.execute();
```


### SetMyFcmToken
#### Required Arguments
```dart
String token = ...;
DefaultConnector.instance.setMyFcmToken(
  token: token,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SetMyFcmTokenData, SetMyFcmTokenVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.setMyFcmToken(
  token: token,
);
SetMyFcmTokenData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String token = ...;

final ref = DefaultConnector.instance.setMyFcmToken(
  token: token,
).ref();
ref.execute();
```


### SetNotificationPrefs
#### Required Arguments
```dart
AnyValue prefs = ...;
DefaultConnector.instance.setNotificationPrefs(
  prefs: prefs,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SetNotificationPrefsData, SetNotificationPrefsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.setNotificationPrefs(
  prefs: prefs,
);
SetNotificationPrefsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
AnyValue prefs = ...;

final ref = DefaultConnector.instance.setNotificationPrefs(
  prefs: prefs,
).ref();
ref.execute();
```


### AddMySkill
#### Required Arguments
```dart
String skillId = ...;
SkillRelation relation = ...;
DefaultConnector.instance.addMySkill(
  skillId: skillId,
  relation: relation,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddMySkill, we created `AddMySkillBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddMySkillVariablesBuilder {
  ...
   AddMySkillVariablesBuilder proficiency(String? t) {
   _proficiency.value = t;
   return this;
  }

  ...
}
DefaultConnector.instance.addMySkill(
  skillId: skillId,
  relation: relation,
)
.proficiency(proficiency)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddMySkillData, AddMySkillVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.addMySkill(
  skillId: skillId,
  relation: relation,
);
AddMySkillData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String skillId = ...;
SkillRelation relation = ...;

final ref = DefaultConnector.instance.addMySkill(
  skillId: skillId,
  relation: relation,
).ref();
ref.execute();
```


### RemoveMySkill
#### Required Arguments
```dart
String skillId = ...;
SkillRelation relation = ...;
DefaultConnector.instance.removeMySkill(
  skillId: skillId,
  relation: relation,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RemoveMySkillData, RemoveMySkillVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.removeMySkill(
  skillId: skillId,
  relation: relation,
);
RemoveMySkillData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String skillId = ...;
SkillRelation relation = ...;

final ref = DefaultConnector.instance.removeMySkill(
  skillId: skillId,
  relation: relation,
).ref();
ref.execute();
```


### RejectRequest
#### Required Arguments
```dart
String requestId = ...;
DefaultConnector.instance.rejectRequest(
  requestId: requestId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RejectRequestData, RejectRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.rejectRequest(
  requestId: requestId,
);
RejectRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String requestId = ...;

final ref = DefaultConnector.instance.rejectRequest(
  requestId: requestId,
).ref();
ref.execute();
```

