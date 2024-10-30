
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';
import 'home.dart';
Future<String> getPublicIp() async {
  try {
    final response = await http.get(Uri.parse('https://api64.ipify.org?format=json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['ip'];
    } else {
      throw Exception('Failed to get public IP');
    }
  } catch (e) {
    print('Error: $e');
    return '';
  }
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String publicIp = await getPublicIp();
  print(publicIp);
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