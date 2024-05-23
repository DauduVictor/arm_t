import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

class Functions {
  static void trackButtonClickedEvent({
    String? buttonEvent,
  }) async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(
        name: buttonEvent ?? 'user_event',
      ).then((value) {
      });
    } catch (e) {
      log('user error ::: ${e.toString()}');
    }
  }
}