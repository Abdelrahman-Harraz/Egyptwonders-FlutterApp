import 'package:egypt_wonders/features/home/repos/emergency_repos.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EmergencyContactButton(
            icon: Icons.local_police,
            label: 'Police',
            phoneNumber: 'tel:123',
          ),
          _EmergencyContactButton(
            icon: Icons.local_hospital,
            label: 'Ambulance',
            phoneNumber: 'tel:456',
          ),
          _EmergencyContactButton(
            icon: Icons.fire_extinguisher,
            label: 'Fire Department',
            phoneNumber: 'tel:789',
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String phoneNumber;

  const _EmergencyContactButton({
    required this.icon,
    required this.label,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EmergencyRepository.launchUrlFunction("tel://123");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: OwnTheme.primaryColor),
            SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Function to make a call
  void _makeCall() async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      // Handle error
      print('Could not launch $phoneNumber');
    }
  }
}
