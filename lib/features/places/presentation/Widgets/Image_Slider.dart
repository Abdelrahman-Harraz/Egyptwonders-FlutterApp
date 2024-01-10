import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EventImageSlider extends StatefulWidget {
  final List<String> imagesUrl;

  // Constructor to initialize the 'imagesUrl'
  EventImageSlider({Key? key, required this.imagesUrl});

  @override
  State<EventImageSlider> createState() => _EventImageSliderState();
}

class _EventImageSliderState extends State<EventImageSlider> {
  // Controller for managing the carousel
  final controller = CarouselController();

  // Index of the active page for the smooth page indicator
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Carousel for displaying images
      CarouselSlider.builder(
        carouselController: controller,
        itemCount: widget.imagesUrl.length,
        itemBuilder: (context, index, realIndex) {
          final urlImage = widget.imagesUrl[index];
          return buildImage(urlImage, index);
        },
        options: CarouselOptions(
          viewportFraction: 1.5,
          height: 400,
          autoPlay: false,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(seconds: 2),
          enlargeCenterPage: true,
          onPageChanged: (index, reason) => setState(() => activeIndex = index),
        ),
      ),
      // Positioning the smooth page indicator
      Positioned(
        top: 45.h,
        left: 40.w,
        child: buildIndicator(),
      ),
    ]);
  }

  // Widget for building individual images
  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: CachedNetworkImage(
        imageUrl: urlImage,
        fit: BoxFit.cover,
      ),
    );
  }

  // Widget for building the smooth page indicator
  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      // Callback when a dot is clicked
      onDotClicked: (index) {
        setState(() {
          activeIndex = index;
          // Animating the carousel to the selected page
          controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      },
      // Style of the indicator dots
      effect: ExpandingDotsEffect(
        dotHeight: 1.h,
        dotWidth: 2.w,
        activeDotColor: OwnTheme.primaryColor,
      ),
      // Current active index
      activeIndex: activeIndex,
      // Total number of dots
      count: widget.imagesUrl.length,
    );
  }
}
