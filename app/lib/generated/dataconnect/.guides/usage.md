# Basic Usage

```dart
DefaultConnector.instance.UpsertCurrentUser(upsertCurrentUserVariables).execute();
DefaultConnector.instance.UpdateMyProfile(updateMyProfileVariables).execute();
DefaultConnector.instance.SetMyResume(setMyResumeVariables).execute();
DefaultConnector.instance.DeleteMyResume().execute();
DefaultConnector.instance.SetMyFcmToken(setMyFcmTokenVariables).execute();
DefaultConnector.instance.SetNotificationPrefs(setNotificationPrefsVariables).execute();
DefaultConnector.instance.AddMySkill(addMySkillVariables).execute();
DefaultConnector.instance.RemoveMySkill(removeMySkillVariables).execute();
DefaultConnector.instance.RejectRequest(rejectRequestVariables).execute();
DefaultConnector.instance.GetCurrentUser().execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await DefaultConnector.instance.AddMySkill({ ... })
.proficiency(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

