import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/complete_profile_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/certificate/presentation/certificate_screen.dart';
import '../../features/about/presentation/about_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/chat/presentation/chat_thread_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/discovery/domain/offering.dart';
import '../../features/discovery/presentation/search_screen.dart';
import '../../features/discovery/presentation/skill_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notifications/presentation/notification_settings_screen.dart';
import '../../features/paths/presentation/learning_paths_screen.dart';
import '../../features/paths/presentation/path_detail_screen.dart';
import '../../features/profile/domain/profile.dart';
import '../../features/quiz/domain/teaching_session.dart';
import '../../features/quiz/presentation/learner_quizzes_screen.dart';
import '../../features/quiz/presentation/post_session_form_screen.dart';
import '../../features/quiz/presentation/quiz_approval_screen.dart';
import '../../features/quiz/presentation/quiz_attempt_screen.dart';
import '../../features/quiz/presentation/quiz_result_screen.dart';
import '../../features/quiz/presentation/teaching_sessions_screen.dart';
import '../../features/requests/domain/accepted_request.dart';
import '../../features/requests/presentation/pre_session_form_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/manage_skills_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/trust_quiz_screen.dart';
import '../../features/rewards/presentation/rewards_screen.dart';
import 'main_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();

const _authRoutes = {'/login', '/register', '/forgot-password'};

/// The app router. Its redirect is driven by [appAuthStateProvider]; a
/// [ChangeNotifier] bridge re-runs the redirect whenever auth state changes.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(appAuthStateProvider).valueOrNull;
      final loc = state.matchedLocation;

      switch (status) {
        case null:
        case AuthStatus.unknown:
          // Still resolving the first auth emission — hold on the splash.
          return loc == '/splash' ? null : '/splash';
        case AuthStatus.unauthenticated:
          return _authRoutes.contains(loc) ? null : '/login';
        case AuthStatus.needsVerification:
          return loc == '/verify-email' ? null : '/verify-email';
        case AuthStatus.needsProfile:
          return loc == '/complete-profile' ? null : '/complete-profile';
        case AuthStatus.ready:
          final onGate = loc == '/splash' ||
              loc == '/verify-email' ||
              loc == '/complete-profile' ||
              _authRoutes.contains(loc);
          return onGate ? '/home' : null;
      }
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (_, _) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (_, _) => const CompleteProfileScreen(),
      ),
      GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
      GoRoute(
        path: '/offering',
        builder: (context, state) =>
            SkillDetailScreen(offering: state.extra! as Offering),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) =>
            EditProfileScreen(profile: state.extra! as Profile),
      ),
      GoRoute(
        path: '/profile/skills',
        builder: (_, _) => const ManageSkillsScreen(),
      ),
      GoRoute(
        path: '/trust-quiz',
        builder: (_, _) => const TrustQuizScreen(),
      ),
      GoRoute(
        path: '/pre-session',
        builder: (context, state) =>
            PreSessionFormScreen(request: state.extra! as AcceptedTeachingRequest),
      ),
      GoRoute(
        path: '/teaching',
        builder: (_, _) => const TeachingSessionsScreen(),
      ),
      GoRoute(
        path: '/post-session-form',
        builder: (context, state) =>
            PostSessionFormScreen(session: state.extra! as TeachingSession),
      ),
      GoRoute(
        path: '/quiz-approval',
        builder: (context, state) =>
            QuizApprovalScreen(args: state.extra! as QuizApprovalArgs),
      ),
      GoRoute(path: '/quizzes', builder: (_, _) => const LearnerQuizzesScreen()),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/chat-thread',
        builder: (context, state) =>
            ChatThreadScreen(args: state.extra! as ChatThreadArgs),
      ),
      GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
      GoRoute(
        path: '/certificate',
        builder: (context, state) =>
            CertificateScreen(pathId: state.extra! as String),
      ),
      GoRoute(path: '/paths', builder: (_, _) => const LearningPathsScreen()),
      GoRoute(
        path: '/path',
        builder: (context, state) =>
            PathDetailScreen(pathId: state.extra! as String),
      ),
      GoRoute(
        path: '/quiz-attempt',
        builder: (context, state) =>
            QuizAttemptScreen(quizId: state.extra! as String),
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (context, state) =>
            QuizResultScreen(args: state.extra! as QuizResultArgs),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/chat', builder: (_, _) => const ChatListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/rewards', builder: (_, _) => const RewardsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/dashboard',
                builder: (_, _) => const DashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/profile', builder: (_, _) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});

/// Notifies go_router to re-evaluate `redirect` on every auth-state change.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    _sub = ref.listen<AsyncValue<AuthStatus>>(
      appAuthStateProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AsyncValue<AuthStatus>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
