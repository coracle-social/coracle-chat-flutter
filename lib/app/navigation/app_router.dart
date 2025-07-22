import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frb_example_gallery/app/components/home_page.dart';
import 'package:frb_example_gallery/app/components/settings_page.dart';
import 'package:frb_example_gallery/app/components/simple_example.dart';
import 'package:frb_example_gallery/app/components/zaplab_modal_content.dart';
import 'package:frb_example_gallery/app/components/example_modal_content.dart';
import 'package:frb_example_gallery/app/components/profile_page.dart';
import 'responsive_scaffold.dart';
import 'dialog_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ResponsiveScaffold(
          child: navigationShell,
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
                // Modal routes nested under home
                GoRoute(
                  path: 'zaplab',
                  pageBuilder: (context, state) => buildDialogPage(
                    const ZaplabModalContent(),
                  ),
                ),
                GoRoute(
                  path: 'example-modal',
                  pageBuilder: (context, state) => buildDialogPage(
                    const ExampleModalContent(
                      title: 'Reusable Modal Example',
                      content: 'This demonstrates how easy it is to create new modal routes with any content!',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/simple',
              builder: (context, state) => Scaffold(
                appBar: AppBar(
                  title: const Text('Simple Rust Functions'),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                body: const SimpleExamplePageBody(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);