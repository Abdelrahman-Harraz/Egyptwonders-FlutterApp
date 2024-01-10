// Importing necessary packages and files
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_buttom_sheet.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';

// Class containing a static method to display a bottom sheet
class BTMSheet {
  static Future<void> displayBTMSheet({
    required BuildContext context,
    required String title,
    required String primaryButtomLabel,
    required void Function() primaryFunction,
    required Widget body,
  }) async {
    return showModalBottomSheet(
      backgroundColor: OwnTheme.white,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: ((context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.minHeight,
              ),
              child: CustomButtomSheet(
                title: title,
                primaryButtomLabel: primaryButtomLabel,
                primaryFunction: primaryFunction,
                body: body,
              ),
            );
          },
        );
      }),
    );
  }
}
