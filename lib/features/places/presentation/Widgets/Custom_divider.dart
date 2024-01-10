import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';

Widget CustomDivider() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: side),
    child: const Divider(
      thickness: 2.0,
      color: Colors.black,
    ),
  );
}
