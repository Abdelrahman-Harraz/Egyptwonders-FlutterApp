import 'package:egypt_wonders/features/qrCode/presentation/screen/qr_scanner_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';

class Scanbutton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, QRViewScreen.routeName);
      },
      child: ImageIcon(
        AssetImage('assets/images/Iconscan.png'),
        size: 30.0,
      ),
      backgroundColor: OwnTheme.primaryColor,
    );
  }
}
