import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/services/auth_service.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/home/create_room_screen.dart';
import '../features/home/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/join_code_screen.dart';
import '../features/home/notifications_screen.dart';
import '../features/room/define_link_screen.dart';
import '../features/room/lobby_screen.dart';
import '../features/room/room_broadcast_screen.dart';
import '../features/room/room_browse_screen.dart';
import '../features/room/room_sync_screen.dart';
import '../features/settings/audio_video_screen.dart';
import '../features/settings/help_diagnostics_screen.dart';
import '../features/settings/legal_screen.dart';
import '../features/settings/network_performance_screen.dart';
import '../features/settings/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/states/error_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      ref.read(authServiceProvider).authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/onboarding';
      if (!isLoggedIn && !isAuthRoute && state.uri.path != '/') {
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/create-room',
        builder: (context, state) => const CreateRoomScreen(),
      ),
      GoRoute(
        path: '/join-code',
        builder: (context, state) => const JoinCodeScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/lobby',
        builder: (context, state) => const LobbyScreen(),
      ),
      GoRoute(
        path: '/define-link',
        builder: (context, state) => const DefineLinkScreen(),
      ),
      GoRoute(
        path: '/room-sync',
        builder: (context, state) => const RoomSyncScreen(),
      ),
      GoRoute(
        path: '/room-browse',
        builder: (context, state) => const RoomBrowseScreen(),
      ),
      GoRoute(
        path: '/room-broadcast',
        builder: (context, state) => const RoomBroadcastScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/audio-video',
        builder: (context, state) => const AudioVideoScreen(),
      ),
      GoRoute(
        path: '/settings/network',
        builder: (context, state) => const NetworkPerformanceScreen(),
      ),
      GoRoute(
        path: '/settings/help',
        builder: (context, state) => const HelpDiagnosticsScreen(),
      ),
      GoRoute(
        path: '/settings/legal',
        builder: (context, state) => const LegalScreen(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => const ErrorScreen(),
      ),
    ],
  );
});
