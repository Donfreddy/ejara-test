import 'dart:developer';

import 'package:ejara_test/config.dart';
import 'package:ejara_test/home.dart';
import 'package:ejara_test/pusher_beams.dart';
import 'package:flutter/material.dart';

void main() async {
  log(Properties.instanceId);

  // Initialize PusherBeams as soon as possible (here is RECOMMENDED)
  await PusherBeams.start(Properties.instanceId);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
