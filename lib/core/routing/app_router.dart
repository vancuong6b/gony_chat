import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/community/screens/feed_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/character_detail_screen.dart';
import '../../features/chat/screens/chat_list_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/community/models/character.dart';
// ĐÃ XÓA dòng import mock_data.dart
import '../../shared/screens/main_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorCommunityKey = GlobalKey<NavigatorState>(debugLabel: 'community');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _shellNavigatorStudioKey = GlobalKey<NavigatorState>(debugLabel: 'studio');
final _shellNavigatorChatKey = GlobalKey<NavigatorState>(debugLabel: 'chat');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCommunityKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const FeedScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const CommunityScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStudioKey,
          routes: [
            GoRoute(
              path: '/studio',
              builder: (context, state) => const Scaffold(body: Center(child: Text('Studio'))),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorChatKey,
          routes: [
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/character-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final character = state.extra as Character;
        return CharacterDetailScreen(character: character);
      },
    ),
    GoRoute(
      path: '/chat-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final character = state.extra as Character;
        return ChatScreen(character: character);
      },
    ),
  ],
);