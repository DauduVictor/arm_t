import 'package:arm_test/theme/theme.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final Color labelColor;
  final Color? color;
  final Widget? child;
  final double verticalPadding;
  final double? width;
  final bool isBoldLabelText;
  final bool enabled;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.labelColor = AppColors.white,
    this.child,
    this.color,
    this.width,
    this.verticalPadding = 17.5,
    this.isBoldLabelText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: enabled ? 1 : 0,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        backgroundColor: enabled
            ? color ?? AppColors.brown4E
            : AppColors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: enabled ? null : const BorderSide(color: AppColors.brown4E),
      ),
      onPressed: onPressed,
      child: IntrinsicWidth(
        child: SizedBox(
          width: width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                child: Row(
                  children: [
                    child ??
                        Text(
                          label,
                          textScaler: const TextScaler.linear(1),
                          style: textTheme.bodyLarge!.copyWith(
                            color: enabled ? labelColor : AppColors.white,
                            fontWeight: isBoldLabelText
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
