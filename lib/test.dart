import 'dart:developer';

import 'package:ejara_test/pusher.dart';
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late PusherClient pusher;
  late Channel channel;

  @override
  void initState() {
    super.initState();

    pusher = PusherClient(
      appKey,
      PusherOptions(cluster: cluster),
    );

    channel = pusher.subscribe("private-orders");

    pusher.onConnectionStateChange((state) {
      log("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });

    pusher.onConnectionError((error) {
      log("error: ${error!.message}");
    });

    channel.bind('status-update', (event) {
      log(event!.data.toString());
    });

    channel.bind('order-filled', (event) {
      log("Order Filled Event" + event!.data.toString());
    });
  }

  String getToken() => "super-secret-token";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Pusher App'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Unsubscribe Private Orders'),
              onPressed: () {
                pusher.unsubscribe('private-orders');
              },
            ),
            ElevatedButton(
              child: const Text('Unbind Status Update'),
              onPressed: () {
                channel.unbind('status-update');
              },
            ),
            ElevatedButton(
              child: const Text('Unbind Order Filled'),
              onPressed: () {
                channel.unbind('order-filled');
              },
            ),
            ElevatedButton(
              child: const Text('Bind Status Update'),
              onPressed: () {
                channel.bind('status-update', (PusherEvent? event) {
                  log("Status Update Event" + event!.data.toString());
                });
              },
            ),
            ElevatedButton(
              child: const Text('Trigger Client Typing'),
              onPressed: () {
                channel.trigger('client-istyping', {'name': 'Bob'});
              },
            ),
          ],
        ),
      ),
    );
  }
}
