import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

// A utility class for handling UI failures
class FailureUiHandling {
  // Method to show a toast message for error handling
  static void showToast({
    required BuildContext context,
    required String errorMsg,
    Color color = Colors.red,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: errorMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: OwnTheme.Red,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  // Method to create a centered message widget with auto-sizing text
  static Widget centeredMessageBuilder(String message) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: AutoSizeText(
          message,
          maxLines: 4,
          textAlign: TextAlign.center,
          style: OwnTheme.bodyTextStyle(),
        ),
      ),
    );
  }

  // Method to create a media failure widget with an error icon and a "Try again" message
  static Widget mediaFailureWidget(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error),
          Text(
            "Try again",
            style: OwnTheme.bodyTextStyle(),
          ),
        ],
      ),
    );
  }
}
