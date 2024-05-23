import 'package:arm_test/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    required this.textEditingController,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.obscuringCharacter = '*',
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.bottomSpacing = true,
    this.maxLength,
    this.autofocus = false,
    this.hintColor = AppColors.greyED,
    this.borderColor,
    this.focusedBorderColor,
    this.height,
    this.helperText,
    this.helperColor,
    this.fontSize,
    this.textFieldName,
    this.obscureCharacter,
    this.onSaved,
    this.onSubmitted,
    this.onEditingComplete,
    this.borderWidth = 1,
  });

  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final Widget? suffix;
  final Widget? prefix;
  final bool readOnly;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String obscuringCharacter;
  final AutovalidateMode? autoValidateMode;
  final bool? bottomSpacing;
  final int? maxLength;
  final bool autofocus;
  final Color hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? height;
  final String? helperText;
  final Color? helperColor;
  final double? fontSize;
  final String? textFieldName;
  final Widget? obscureCharacter;
  final Function(String?)? onSaved;
  final Function(String?)? onSubmitted;
  final Function()? onEditingComplete;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: height,
              child: TextFormField(
                controller: textEditingController,
                onChanged: onChanged,
                validator: validator,
                obscureText: obscureText,
                maxLines: maxLines,
                cursorColor: AppColors.brown4E,
                autovalidateMode: autoValidateMode,
                readOnly: readOnly,
                maxLength: maxLength,
                textInputAction: textInputAction,
                autofocus: autofocus,
                onSaved: onSaved,
                onFieldSubmitted: onSubmitted,
                onEditingComplete: onEditingComplete,
                textCapitalization: textCapitalization,
                keyboardType: keyboardType,
                obscuringCharacter: obscuringCharacter,
                autocorrect: false,
                style: textTheme.bodyMedium!.copyWith(
                  fontSize: fontSize,
                  color: AppColors.black,
                ),
                onTap: onTap,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                  helperText: helperText,
                  helperStyle: textTheme.bodySmall!.copyWith(
                    color: AppColors.black,
                  ),
                  suffixIcon: suffix,
                  // suffix: suffix,
                  prefixIcon: prefix,
                  hintText: hintText ?? textFieldName,
                  hintStyle: textTheme.bodyMedium!.copyWith(
                    color: AppColors.black.withOpacity(0.3),
                    fontWeight: FontWeight.w500,
                  ),
                  labelText: labelText,
                  labelStyle:
                      textTheme.titleMedium!.copyWith(color: AppColors.greyED),
                  focusColor: AppColors.brown4E,
                  fillColor: Colors.transparent,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 3, 18),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.black,
                      width: borderWidth,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.black,
                      width: borderWidth,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.black,
                      width: borderWidth,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.brownC8,
                      width: borderWidth,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (bottomSpacing == true) SizedBox(height: 25.h),
      ],
    );
  }
}

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    required this.textEditingController,
    this.textFieldName,
    this.hintText,
    this.isBottomSpacing = true,
    this.validator,
    super.key,
  });

  final TextEditingController textEditingController;
  final String? textFieldName;
  final String? hintText;
  final bool isBottomSpacing;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    return CustomTextFormField(
      textEditingController: textEditingController,
      textFieldName: textFieldName,
      obscureText: obscureText.value,
      bottomSpacing: isBottomSpacing,
      validator: validator,
      hintText: hintText,
      suffix: InkWell(
        onTap: () => obscureText.value = !obscureText.value,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            !obscureText.value ? Icons.visibility : Icons.visibility_off,
            size: 17.sp,
            color: AppColors.brown38.withOpacity(0.6),
          ),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }
}
