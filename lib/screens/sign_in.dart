import 'package:arm_test/extensions.dart';
import 'package:arm_test/features/features.dart';
import 'package:arm_test/screens/screens.dart';
import 'package:arm_test/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignIn extends HookWidget {
  static const String id = 'signIn';
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mqr = MediaQuery.of(context).size;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useState(GlobalKey<FormState>());
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (error) => ShowMessage.showSnackBar(
            context,
            error.toString(),
          ),
          signIn: (user) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: user,
                ),
              ),
              (route) => false),
        );
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state == const AuthState.loading(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: formKey.value,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Welcome Back!',
                              textScaler: const TextScaler.linear(1),
                              style: textTheme.headlineSmall!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Lets get you quickly logged in',
                              textScaler: const TextScaler.linear(1),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          CustomTextFormField(
                            textFieldName: 'Email Address',
                            textEditingController: emailController,
                            validator: context.validateEmailAddress,
                          ),
                          PasswordTextField(
                            textFieldName: 'Password',
                            textEditingController: passwordController,
                            validator: (val) =>
                                context.validateFieldNotEmpty(val, 'Password'),
                            isBottomSpacing: false,
                          ),
                          SizedBox(height: 30.h),
                          Button(
                            label: 'Continue',
                            width: mqr.width,
                            onPressed: () {
                              if (formKey.value.currentState!.validate()) {
                                context.read<AuthCubit>().signIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                              }
                            },
                            child: state == const AuthState.loading()
                                ? const CustomSpinner()
                                : null,
                          ),
                          SizedBox(height: 35.h),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: AppColors.greyED,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'OR',
                                  textScaler: const TextScaler.linear(1),
                                  style: textTheme.bodyMedium!.copyWith(),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: AppColors.greyED,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Don't have an account? ",
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: AppColors.brown4E,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        Navigator.pushReplacementNamed(
                                            context, SignUp.id),
                                ),
                              ],
                              style: textTheme.bodyMedium!.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ].animate(interval: 1.ms).fade(),
              ),
            ),
          ),
        );
      },
    );
  }
}
