import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// CustomButton widget
class CustomButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final Color? color;

  // Constructor for the CustomButton widget
  CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingAll),
      child: Container(
        height: 6.5.h,
        width: 80.w,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              color ?? OwnTheme.callToActionColor,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide.none,
              ),
            ),
          ),
          child: Text(
            label,
            style: OwnTheme.bodyTextStyle(),
          ),
        ),
      ),
    );
  }
}
