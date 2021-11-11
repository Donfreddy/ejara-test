import 'dart:developer';

import 'package:ejara_test/pusher.dart';
import 'package:ejara_test/pusher_beams.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PusherProvider pusherProvider = PusherProvider();

  @override
  void initState() {
    pusherProvider.initializeNotifications();
    super.initState();
    pusherProvider.initPusher('Freddy');
    initPusherBeams();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPusherBeams() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // As in Pusher Beams Get Started
      await PusherBeams.addDeviceInterest('hello');

      // For debug purposes on Debug Console
      await PusherBeams.addDeviceInterest('debug-hello');

      final interests = await PusherBeams.getDeviceInterests();

      for (var interest in interests) {
        log('Interest: $interest');
      }
    } catch (e) {
      log("Exception D:" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusher Beams Example'),
      ),
      body: const Center(
        child: Text("You can test your notifications now"),
      ),
    );
  }
}
