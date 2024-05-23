import 'dart:async';
import 'dart:developer';
import 'package:arm_test/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_bloc_observer.dart';
import 'features/features.dart';
import 'screens/screens.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage remoteMessage,
) async {
  log('Handling a background message ${remoteMessage.messageId}');
  //navigate(remoteMessage.data);
}

void main() {
  unawaited(
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );
        Bloc.observer = AppBlocObserver();
        runApp(const MyApp());
      },
      (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
    ),
  );
  unawaited(
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return Unfocus(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => AuthCubit(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Arm Test',
              theme: AppTheme.themeData,
              initialRoute: SplashScreen.id, 
              routes: {
                SplashScreen.id: (context) => const SplashScreen(),
                SignUp.id: (context) => const SignUp(),
                SignIn.id: (context) => const SignIn(),
                HomePage.id: (context) => const HomePage(),
                UserChat.id: (context) => const UserChat(),
              },
            ),
          ),
        );
      },
    );
  }
}
