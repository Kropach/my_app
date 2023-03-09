import 'package:flutter/material.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/main_screen.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(-6523038),
          secondary: Color(-6523038)
        )
    ),
    initialRoute: '/',
    routes: {
      '/' : (context) => MainScreen(),
      '/bookMarks' : (context) => Home()
    },
  )
);