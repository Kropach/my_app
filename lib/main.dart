import 'package:flutter/material.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/create_bookmark.dart';
import 'package:my_app/pages/main_screen.dart';
import 'package:my_app/pages/book_manager.dart';
import 'package:my_app/pages/create_book_manager_mark.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(-7840182),
          secondary: Color(-6523038)
        )
    ),
    initialRoute: '/',
    routes: {
      '/' : (context) => const MainScreen(),
      '/bookMarks' : (context) => const Home(),
      '/createBookmark' : (context) => const CreateBookmark(id: "", author: "",
          title: "", text: ""),
      '/bookManager' : (context) => const BookManager(),
      '/createBookManagerMark': (context) => const CreateBookManagerMark(
          id: '', author: '', title: '',
          icon: 'waiting', isInShoplist: 'N'
      )
    },
  )
);