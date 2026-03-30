import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/views/home.view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'GIF Hunter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.orange.withOpacity(0.3),
            selectionHandleColor: Colors.orange,
            cursorColor: Colors.orange,
          ),
        ),
        home: const HomeView(),
      ),
    ),
  );
}
