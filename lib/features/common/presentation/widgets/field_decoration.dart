import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/theme.dart';
import "package:flutter/material.dart";
import 'package:sizer/sizer.dart';

// AuthScreensFieldDecoration class for defining field decorations
class AuthScreensFieldDecoration {
  static const double betweenFieldsSpace = 10;

// Method for creating field decoration
  static InputDecoration fieldDecoration(String label, IconData? iconData,
      {required BuildContext context,
      bool? passwordVisible,
      Function? togglePasswordVisibility,
      IconData? suffix,
      bool floatingLable = false}) {
    // Define outline input border
    var outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(40),
      gapPadding: 5.sp,
    );
    // Define underline input border
    var underlineInputBorder = OutlineInputBorder(
      gapPadding: 20,
      borderSide: BorderSide(width: 1, color: OwnTheme.LightBlack),
      borderRadius: const BorderRadius.all(
        Radius.circular(borderRadius),
      ),
    );

    return InputDecoration(
      alignLabelWithHint: true,
      errorStyle: TextStyle(fontSize: 10.sp, height: 0.2, color: OwnTheme.Red),
      labelStyle: OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.LightBlack),
      filled: true,
      floatingLabelAlignment: FloatingLabelAlignment.center,
      floatingLabelBehavior: floatingLable
          ? FloatingLabelBehavior.auto
          : FloatingLabelBehavior.never,
      fillColor: OwnTheme.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: OwnTheme.grey, width: 2.0),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: OwnTheme.grey, width: 2.0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      errorMaxLines: 1,
      label: Text(label),
      prefixIcon: iconData != null
          ? Icon(
              iconData,
              size: 6.w,
              color: OwnTheme.grey,
            )
          : null,
      focusedErrorBorder: underlineInputBorder,
      errorBorder: underlineInputBorder,
      border: outlineInputBorder,
      constraints: BoxConstraints(minHeight: 6.h, maxHeight: 8.h),
      suffixIcon: passwordVisible != null
          ? IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: OwnTheme.grey),
              onPressed: () => togglePasswordVisibility!(),
            )
          : suffix != null
              ? Icon(
                  suffix,
                  size: 6.w,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
    );
  }
}
