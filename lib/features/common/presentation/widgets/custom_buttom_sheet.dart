// Importing necessary packages and files
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Custom_divider.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// CustomButtomSheet widget
class CustomButtomSheet extends StatelessWidget {
  final String title;
  final String primaryButtomLabel;
  final void Function() primaryFunction;
  final Widget body;

  // Constructor for the CustomButtomSheet widget
  CustomButtomSheet({
    Key? key,
    required this.title,
    required this.primaryButtomLabel,
    required this.primaryFunction,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 1.w),
          child: const Divider(
            thickness: 3,
            color: OwnTheme.primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: side),
          child: Text(
            title,
            style: OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
          ),
        ),
        CustomDivider(),
        Padding(padding: const EdgeInsets.all(side), child: body),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: CustomButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                },
                color: OwnTheme.darkTextColor,
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomButton(
                label: primaryButtomLabel,
                onPressed: primaryFunction,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
