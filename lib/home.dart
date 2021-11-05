import 'package:ejara_test/pusher.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificataion'),
      ),
      body: Container(),
    );
  }
}
