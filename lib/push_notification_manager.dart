import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsManager {
  factory PushNotificationsManager() => _instance;
  PushNotificationsManager._();

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late FirebaseApp _app;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Define a top-level named handler which background/terminated messages will
  /// call.
  ///
  /// To verify things are working, check out the native platform logs.
  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage,
  ) async {
    await Firebase.initializeApp();
    log('Handling a background message ${remoteMessage.messageId}');
    //navigate(remoteMessage.data);
  }

  Future<void> init() async {
    
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      unawaited(
        _firebaseMessaging.requestPermission(
          criticalAlert: true,
        ),
      );
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    _app = await Firebase.initializeApp();
    log('Initialized default app $_app');
    // For iOS request permission first.
    unawaited(_firebaseMessaging.requestPermission());
    _triggerFirebase();

    // For testing purposes log the Firebase Messaging token
    final token = await _firebaseMessaging.getToken();
    log('FirebaseMessaging token: $token');
  }

  void _triggerFirebase() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) async {
      if (remoteMessage != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      final notification = message!.notification;
      final android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage remoteMessage) async {
      log('A new onMessageOpenedApp event was published!');
      log('onResume');
      log('data from remote notification::: ${remoteMessage.data}');
      log('notification title ::: ${remoteMessage.notification?.body}');
      log('notification body ::: ${remoteMessage.notification?.title}');
      //navigate(remoteMessage.data);
    });
    log('FirebaseMessaging: Configured');
  }
}
