import 'package:arm_test/core/models/chat_message_model.dart';
import 'package:arm_test/features/features.dart';
import 'package:arm_test/screens/screens.dart';
import 'package:arm_test/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
    final chatHistory = useState<List<ChatMessageModel>>([]);

    /// Format DateTime to `e.g 12:30 pm`
    String getTimeOfDay(DateTime date) {
      return DateFormat('hh:mm a').format(date).toLowerCase();
    }

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
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
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
                ),
                const SizedBox(height: 4),
                const Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: RawScrollbar(
                      thumbColor: AppColors.brown4E.withOpacity(0.8),
                      radius: const Radius.circular(5),
                      thickness: 1.5,
                      thumbVisibility: false,
                      minOverscrollLength: 0.5,
                      child: chatHistory.value.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    for (final chat in chatHistory.value)
                                      ChatBubble(
                                        message: chat.message,
                                        sentByCurrentUser:
                                            chat.sentByCurrentUser,
                                        timeSent: getTimeOfDay(
                                          chat.time ?? DateTime.now(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              // add chat to history
                              chatHistory.value = [
                                ...chatHistory.value,
                                ChatMessageModel(
                                  message: chatTextController.text.trim(),
                                  sentByCurrentUser: true,
                                  time: DateTime.now(),
                                ),
                              ];
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
                          onLongPress: () {
                            if (chatTextController.text.isNotEmpty) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // add chat to history
                              chatHistory.value = [
                                ...chatHistory.value,
                                ChatMessageModel(
                                  message: chatTextController.text.trim(),
                                  sentByCurrentUser: false,
                                  time: DateTime.now(),
                                ),
                              ];
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
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ].animate(interval: 1.ms).fade(),
            ),
          ),
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.message = '',
    this.sentByCurrentUser = false,
    this.timeSent = '',
    this.messageWidget,
  });

  final String message;
  final bool sentByCurrentUser;
  final String timeSent;
  final Widget? messageWidget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment:
          sentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: sentByCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: sentByCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 12,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                decoration: BoxDecoration(
                  color:
                      sentByCurrentUser ? AppColors.greyED : AppColors.brown4E,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(sentByCurrentUser ? 11 : 2),
                    topRight: Radius.circular(sentByCurrentUser ? 2 : 11),
                    bottomLeft: const Radius.circular(11),
                    bottomRight: const Radius.circular(11),
                  ),
                ),
                child: messageWidget ??
                    Text(
                      message,
                      textScaler: TextScaler.noScaling,
                      textAlign: TextAlign.left,
                      style: textTheme.bodyLarge!.copyWith(
                        color: sentByCurrentUser
                            ? AppColors.black
                            : AppColors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            timeSent,
            textScaler: TextScaler.noScaling,
            textAlign: TextAlign.left,
            style: textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 19),
        ],
      ),
    );
  }
}
