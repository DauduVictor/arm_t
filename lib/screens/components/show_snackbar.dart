import 'package:arm_test/theme/theme.dart';
import 'package:flutter/material.dart';

class ShowMessage {
  static showSnackBar(BuildContext context, String message) {
    final textTheme = Theme.of(context).textTheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1600),
      backgroundColor: AppColors.brown4E,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          message,
          style: textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ),
    ));
  }
}
