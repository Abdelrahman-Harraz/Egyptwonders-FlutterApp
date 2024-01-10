// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sizer/sizer.dart';

import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/theme.dart';

// Widget to display price information
class PriceWidget extends StatelessWidget {
  String price; // The price to be displayed
  PriceWidget({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: OwnTheme.primaryColor.withOpacity(1),
                        spreadRadius: 10,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: const ImageIcon(
                    AssetImage('assets/images/ticket.png'),
                    color: OwnTheme.white,
                  )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    price,
                    maxLines: 1,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  AutoSizeText(
                    'Ticket price depends on package',
                    maxLines: 1,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
