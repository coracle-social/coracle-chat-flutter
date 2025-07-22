import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frb_example_gallery/core/bridge/frb_generated.dart';
import 'package:frb_example_gallery/app/navigation/app_router.dart';
import 'package:frb_example_gallery/core/state/nostr_provider.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NostrProvider()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            surface: Colors.white,
            primary: Colors.blue,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
