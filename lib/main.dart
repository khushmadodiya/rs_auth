
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final String uid = uri.queryParameters['uid'] ?? 'default_uid';
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1)),
      title: 'real state',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body:Home(),
      ),
    );
  }
}