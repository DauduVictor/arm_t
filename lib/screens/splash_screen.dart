import 'package:arm_test/constant.dart';
import 'package:arm_test/core/db_provider.dart';
import 'package:arm_test/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/theme.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'splashScreen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    /// Function to navigate to the next screen after the splash screen is completed
    void navigate() async {
      final isLoggedIn =
          await DBProvider().getBoolInSharedPreference(isUserLoggedIn);

      if (isLoggedIn) {
        final email = await DBProvider().getInSharedPreference(userEmail);
        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: email,
            ),
          ),
          (route) => false,
        );
      } else {
        if (!context.mounted) return;
        Navigator.pushNamed(context, SignIn.id);
      }
    }

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.brown4E.withOpacity(0.3),
              radius: 20,
              child: Text(
                'a',
                style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.brown4E),
              ),
            ).animate().shakeY(
                  delay: 500.ms,
                  duration: 3.seconds,
                  hz: 1,
                ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: AppColors.brown4E.withOpacity(0.3),
              radius: 20,
              child: Text(
                'r',
                style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.brown4E),
              ),
            ).animate().shakeY(
                  delay: 500.ms,
                  duration: 3.seconds,
                  curve: Curves.easeIn,
                  hz: 1,
                ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: AppColors.brown4E.withOpacity(0.3),
              radius: 20,
              child: Text(
                'm',
                style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.brown4E),
              ),
            )
                .animate(
                  onComplete: (controller) => navigate(),
                )
                .shakeY(
                  delay: 550.ms,
                  duration: 3.seconds,
                  curve: Curves.easeOut,
                  hz: 1,
                ),
          ],
        ),
      ),
    );
  }
}
