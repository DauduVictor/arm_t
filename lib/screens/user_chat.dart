import 'package:arm_test/features/features.dart';
import 'package:arm_test/screens/screens.dart';
import 'package:arm_test/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserChat extends HookWidget {
  static const String id = 'userChat';
  const UserChat({
    super.key,
    this.name = '',
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scrollController = useScrollController();
    final chatTextController = useTextEditingController();
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
                  Row(
                    children: [
                      Transform.translate(
                        offset: const Offset(-10, 0),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.chevron_left),
                          ),
                        ),
                      ),
                      Hero(
                        tag: name,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.brownC8.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topLeft,
                            child: Text(
                              name,
                              textScaler: const TextScaler.linear(1),
                              style: textTheme.bodyLarge!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Online',
                            textScaler: const TextScaler.linear(1),
                            style: textTheme.bodySmall!.copyWith(
                              color: AppColors.brown4E.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  // Expanded(
                  //   child: RawScrollbar(
                  //     thumbColor: AppColors.brown4E.withOpacity(0.8),
                  //     radius: const Radius.circular(5),
                  //     thickness: 1.5,
                  //     thumbVisibility: false,
                  //     minOverscrollLength: 0.5,
                  //     child: value.conversationMessage.isNotEmpty
                  //         ? ChatView(
                  //             conversationMessages: value.conversationMessage,
                  //             scrollController: scrollController,
                  //           )
                  //         : const SizedBox(),
                  //   ),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          textEditingController: chatTextController,
                          hintText: 'Type message here ...',
                          hintColor: AppColors.brown4E.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Transform.translate(
                        offset: Offset(0, -13.h),
                        child: InkWell(
                          onTap: () {
                            if (chatTextController.text.isNotEmpty) {
                              SchedulerBinding.instance.addPostFrameCallback(
                                (_) {
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                },
                              );
                              chatTextController.clear();
                            }
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.brown38,
                            child: Icon(
                              Icons.send_rounded,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
                ].animate(interval: 1.ms).fade(),
              ),
            ),
          ),
        );
      },
    );
  }
}
