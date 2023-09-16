// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements,, unnecessary_new, prefer_typing_uninitialized_variables, file_names, prefer_const_constructors_in_immutables, avoid_print, avoid_unnecessary_containers, deprecated_member_use, unnecessary_null_comparison, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_course/Test.dart';
import 'package:flutter_course/auth/Login.dart';
import 'package:flutter_course/auth/Signup.dart';
import 'package:flutter_course/functions/AddNotes.dart';
import 'package:flutter_course/functions/EditNotes.dart';
import 'package:flutter_course/home/HomePage.dart';

bool isLogin = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:isLogin==false? Login():HomePage(),
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 231, 119, 156),
        buttonColor: Color.fromARGB(255, 231, 119, 156),
      ),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "home": (context) => HomePage(),
        "addnotes": (context) => AddNotes(),
        "test"   :(context) => Test(),
        "editnote"   :(context) => EditNotes()
      },
    );
  }
}
