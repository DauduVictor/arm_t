import 'dart:io';
import 'package:arm_test/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSpinner extends StatelessWidget {
  const CustomSpinner({
    super.key,
    this.size = 12.0,
    this.color = AppColors.white,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            radius: size,
            color: color,
          )
        : SizedBox(
            width: 23,
            height: 23,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 2,
            ),
          );
  }
}
