import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// LoadingWidget class for displaying a loading spinner
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingAll),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using SpinKitCircle for the loading spinner
          SpinKitCircle(
            color: OwnTheme.primaryColor,
            size: 20.w,
          ),
        ],
      ),
    );
  }
}
