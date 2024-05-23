import 'dart:async';

import 'package:arm_test/features/features.dart';
import 'package:arm_test/screens/screens.dart';
import 'package:arm_test/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends HookWidget {
  static const String id = 'homePage';
  const HomePage({
    super.key,
    this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mqr = MediaQuery.of(context).size;
    final isDummyLoading = useState(true);
    useEffect(
      () {
        Timer.periodic(const Duration(seconds: 2), (t) {
          isDummyLoading.value = false;
        });
        return null;
      },
    );
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (error) => ShowMessage.showSnackBar(
            context,
            error.toString(),
          ),
          logout: (val) => Navigator.pushNamedAndRemoveUntil(
              context, SplashScreen.id, (route) => false),
        );
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state == const AuthState.loading(),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Welcome ${user?.email ?? ''}',
                        textScaler: const TextScaler.linear(1),
                        style: textTheme.bodyLarge!.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'All Messages',
                      textScaler: const TextScaler.linear(1),
                      style: textTheme.bodyMedium!.copyWith(
                        color: AppColors.brown4E.withOpacity(0.4),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  if (isDummyLoading.value)
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const CustomSpinner(
                        color: AppColors.brown4E,
                      ),
                    ),
                  if (isDummyLoading.value == false) ...[
                    const _ChatListWidget(
                      title: 'You',
                      subtitle:
                          'Today is going to be a good day and I am sure of that!',
                      time: '7:00 AM',
                    ),
                    const Divider(),
                    const _ChatListWidget(
                      title: 'Arm Community',
                      subtitle: 'Victor was awesome 👍',
                      time: '1:42 PM',
                    ),
                    const Spacer(),
                    Button(
                      label: 'Log Out',
                      width: mqr.width,
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                      color: AppColors.brown38,
                      verticalPadding: 12,
                      child: state == const AuthState.loading()
                          ? const CustomSpinner()
                          : null,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 10),
                  ],
                ].animate(interval: 1.ms).fade(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChatListWidget extends StatelessWidget {
  const _ChatListWidget({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserChat(name: title),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      horizontalTitleGap: 12,
      leading: Hero(
        tag: title,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.brownC8.withOpacity(0.2),
        ),
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.black.withOpacity(0.6)),
      ),
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          time,
          maxLines: 1,
          style: textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
