import 'package:cached_network_image/cached_network_image.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shimmer/shimmer.dart';

// CustomCachedImage widget
class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double hight;

  // Constructor for the CustomCachedImage widget
  const CustomCachedImage(
      {Key? key,
      required this.imageUrl,
      required this.width,
      required this.hight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageUrl ??
            "https://en.wikipedia.org/wiki/Jason_Statham#/media/File:Jason_Statham_2018.jpg",
        color: OwnTheme.white,
        colorBlendMode: BlendMode.dstATop,
        placeholder: (context, child) {
          return LoadingImageWidget(
            parentSize: Size(width, hight),
            baseShimmerColor: OwnTheme.darkTextColor,
            highlightShimmerColor: OwnTheme.darkTextColor,
          );
        },
        errorWidget: (context, exception, stackTrace) {
          return FailureUiHandling.mediaFailureWidget(
              const Size(double.infinity, double.infinity));
        });
  }
}

// LoadingImageWidget widget
class LoadingImageWidget extends StatelessWidget {
  final Size parentSize;
  final Color baseShimmerColor;
  final Color highlightShimmerColor;

  // Constructor for the LoadingImageWidget widget
  const LoadingImageWidget(
      {super.key,
      required this.parentSize,
      required this.baseShimmerColor,
      required this.highlightShimmerColor});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Shimmer.fromColors(
        baseColor: baseShimmerColor,
        highlightColor: highlightShimmerColor,
        enabled: true,
        child: Container(
            height: parentSize.height * 0.60,
            width: parentSize.width,
            color: OwnTheme.primaryColor),
      ),
    );
  }
}
