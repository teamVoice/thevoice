import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:thevoice2/main.dart';
class FirebaseMessagingService{
  final _firebaseMessaging =  FirebaseMessaging.instance;


  Future<void> initNotification () async{

    // ask for the user permission to get the notification or not
    await _firebaseMessaging.requestPermission();

    // get the token to check for messaging

    final fcmToken =  await _firebaseMessaging.getToken();

    if (kDebugMode) {
      print(fcmToken);
    }
  }

  void handleMessage(RemoteMessage? message) {
    if(message == null) return;

    navigatorkey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message
    );
  }

  Future initPushNotification() async{
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }



}







