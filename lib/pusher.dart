// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_client/pusher_client.dart';

const String appKey = '90296fa61203ccb7819c';
const String username = '';
const String cluster = 'eu';
const int id = 0;
const String payload = '';
const String eventName = 'test-event';
const String eventName2 = 'test-event2';
const String channelName = 'notification-$username';

class PusherProvider {
  late PusherClient pusher;
  late Channel channel;

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotifications() async {
    const initializeAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializeIOS = IOSInitializationSettings();
    const initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);

    await localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> singleNotification(String title, String body) async {
    const androidChannel = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF3AD9F2),
      visibility: NotificationVisibility.public,
      enableVibration: false,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosChannel = IOSNotificationDetails();
    const platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);

    await localNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannel,
      payload: payload,
    );
  }

  Future<void> cancelNotification() async {
    return await localNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    return await localNotificationsPlugin.cancelAll();
  }

  Future<void> initPusher(String username) async {
    pusher = PusherClient(appKey, PusherOptions(cluster: cluster), autoConnect: false);

    // connect at a later time than at instantiation.
    pusher.connect();

    pusher.onConnectionStateChange((state) {
      print("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });

    // Subscribe to a private channel
    channel = pusher.subscribe('notification-$username');

    // Bind to listen for events called eventName and eventName2 sent to
    // 'notification-$username' channel
    channel.bind(eventName, (PusherEvent? event) {
      // var msg = event!.data ?? '';

      // log(msg);
      singleNotification('Title', 'Hello you');
    });

    channel.bind(eventName2, (PusherEvent? event) {
      print(event!.data);
    });
  }

  // Unsubscribe from channel
  void unbindEvent() {
    channel.unbind(eventName);
    channel.unbind(eventName2);
  }

  // Disconnect from pusher service
  void unSubscribePusher(String userame) {
    pusher.unsubscribe('notification-$username');
  }
}
