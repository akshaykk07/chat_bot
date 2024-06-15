

import 'package:chat_bot/homepage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp(
    api_key: dotenv.env['API_KEY'],
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.api_key});
  final String? api_key;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(api_key: api_key),
    );
  }
}

