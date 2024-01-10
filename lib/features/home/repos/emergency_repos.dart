import 'package:url_launcher/url_launcher.dart';

class EmergencyRepository {
  static launchUrlFunction(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) ;
    } catch (e) {}
  }
}
