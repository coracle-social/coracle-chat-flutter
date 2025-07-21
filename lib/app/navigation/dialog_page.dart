import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Helper function to build a dialog page for GoRouter
Page<void> buildDialogPage(Widget child, {
  EdgeInsets insetPadding = const EdgeInsets.all(16),
  BoxConstraints? constraints,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
}) {
  return CustomTransitionPage<void>(
    barrierDismissible: barrierDismissible,
    opaque: false,
    barrierColor: barrierColor,
    fullscreenDialog: true,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: Dialog(
      insetPadding: insetPadding,
      child: Container(
        constraints: constraints ?? const BoxConstraints(
          maxWidth: 800,
          maxHeight: 600,
        ),
        child: child,
      ),
    ),
  );
}

/// Utility class to easily create GoRouter-friendly modal routes
class ModalRouteBuilder {
  /// Creates a GoRoute that displays content as a modal dialog
  static GoRoute createModalRoute({
    required String path,
    required Widget child,
    EdgeInsets insetPadding = const EdgeInsets.all(16),
    BoxConstraints? constraints,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => buildDialogPage(
        child,
        insetPadding: insetPadding,
        constraints: constraints,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      ),
    );
  }
}