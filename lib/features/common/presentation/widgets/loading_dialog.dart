import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

// LoadingDialog class for displaying a loading dialog
class LoadingDialog {
  // Method to display the loading dialog
  static Future<void> displayLoadingDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingWidget();
        });
  }
}
