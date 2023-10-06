
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import './MA_Local_Notification.dart';
class MaFirebaseNotification {
  static Future<void> init() async{ 
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setupInteractedMessage();
    LocalNotificationService.initialize();
    onTokenRefresh();
  }
  static void onTokenRefresh(){
    FirebaseMessaging.instance.onTokenRefresh
    .listen((fcmToken) {
      print('onTokenRefresh::::TODO: If necessary send token to application server.');
      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    })
    .onError((err) {
      // Error getting token.
    });
  }
  
  static Future<String?> getDeviceToken() async {
    //request user permission for push notification
    try{
      //FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
      NotificationSettings settings = await _firebaseMessage.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
        //return 'User granted provisional permission'; 
      } else {
        print('User declined or has not accepted permission');
        //return 'User declined or has not accepted permission';
      }
      String? deviceToken = await _firebaseMessage.getToken();
       print('getDeviceToken:::::deviceToken: "${deviceToken}"');
       if(deviceToken!.isNotEmpty){
          MaUserController.sendToken(deviceToken);
          return deviceToken;
       }

    }catch(e) {
      print('getDeviceToken:::::Error:');
      print(e);
      return "Error retrieving FCM token: $e";
    }
  }


  
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("_firebaseMessagingBackgroundHandler Handling a background message: ${message.messageId}");
    print(message?.data);
  }
  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage1);
    FirebaseMessaging.onMessage.listen(_handleMessage2);
  }
  static void _handleMessage(RemoteMessage message) {
    print('@@@@@  FirebaseMessaging.onMessageOpenedApp.listenner');
    print('@@@@@ Notif message start @@@@@');
    print(message?.data);
    print(message?.notification);

    print('@@@@@ Notif message end @@@@@');
  }
  static void _handleMessage1(RemoteMessage message) {
    print('@@@@@  FirebaseMessaging.onMessageOpenedApp.listenner');
    print('@@@@@ Notif message start @@@@@');
    print(message?.data);
    print(message?.notification);
    LocalNotificationService.onNotificationTap(message?.data);
    print('@@@@@ Notif message end @@@@@');
  }

  static void _handleMessage2(RemoteMessage message) {
    print('@@@@@  FirebaseMessaging.onMessage.listenner');
    print('@@@@@ Notif message start @@@@@');
    print(message?.data);
    print(message?.notification);
    LocalNotificationService.display(message);
    print('@@@@@ Notif message end @@@@@');
  }


}