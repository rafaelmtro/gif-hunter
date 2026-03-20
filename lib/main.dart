import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/views/home.view.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'GIF Hunter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffE6EEF7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffE6EEF7)),
            ),
          ),
        ),
        home: HomeView(),
      ),
    ),
  );
}
