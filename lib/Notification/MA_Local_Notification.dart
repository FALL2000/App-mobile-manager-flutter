import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:x_money_manager/views/full/TransactionDetailsPage.dart';
import 'package:get/get.dart';
import 'package:x_money_manager/Frontend/Views/Full/MA_TransactionDetailsPage.dart';


class LocalNotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    // Initialization setting for android
    const InitializationSettings initializationSettingsAndroid =
    InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()
    );
    _notificationsPlugin.initialize(initializationSettingsAndroid,
        // to handle event when we receive notification
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }
  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    print('onDidReceiveNotificationResponse');
    print(notificationResponse.payload);
    final data = jsonDecode(notificationResponse.payload ?? '{}');
    onNotificationTap(data);
  }
  static void onNotificationTap(data){
    print('@@@@@@@onNotificationTap');
    String action = data['action'] ?? '';
    if(action.isNotEmpty ){
      if(action=='NEW-TRANSACTION-MANAGER') {
        Get.to(MaTransactionDetailsPage(requestId: data['transactionId'],));
      }
    }
  }
  static Future<void> display(RemoteMessage message) async {
    // To display the notification in device

    try {
      print('enter in LocalNotificationService.display(message)');
      print('---->messageId');
      print(message.messageId);
      print('---->messageId');
      print(message.notification!.android!.sound);
      var id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            message.notification!.android!.sound ?? "Channel Id",
            message.notification!.android!.sound ?? "Main Channel",
            color: Colors.green,
            importance: Importance.max,
            icon: '@mipmap/ic_launcher',

            // different sound for
            // different notification
            //playSound: true,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),),
      );
      print('fabrication de notificationDetails end ');
      print(id);
      print('fabrication de notificationDetails end ');
      print(message.notification?.title);
      print(message.notification?.body);
      print(notificationDetails);
      print(message.data);
      print(message.data['action']);
      _notificationsPlugin.show(id, message.notification?.title, message.notification?.body, notificationDetails,
          payload: jsonEncode(message.data));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}