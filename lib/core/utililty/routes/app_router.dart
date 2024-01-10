import 'package:egypt_wonders/features/auth/presentaion/screens/forgot_password_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_form_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/add_review_topup.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/update_place_images_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/upload_images_screen.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_details.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/auth_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/gallery_screen.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/profile_screen.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/features/onBoarding/presentation/onBoarding_screen.dart';
import 'package:egypt_wonders/features/qrCode/presentation/screen/qr_scanner_screen.dart';
import 'package:egypt_wonders/features/qrCode/presentation/screen/video_screen.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/screen/plan_Screen.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/screen/planner_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// Class responsible for managing the app's navigation and page transitions
class AppRouter {
  static const animationDuration = Duration(milliseconds: 600);

// Method to generate and return a PageTransition based on route settings
  static PageTransition? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.size,
          alignment: Alignment.center,
          duration: animationDuration,
          settings: settings,
        );
      case '/HomeScreen':
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/AuthScreen':
        return PageTransition(
          child: const AuthScreen(),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );

      case '/ProfileScreen':
        UserModel userModel = settings.arguments as UserModel;
        return PageTransition(
          child: ProfileScreen(
            user: userModel,
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/GalleryScreen':
        List<String>? name = settings.arguments as List<String>?;
        return PageTransition(
          child: GalleryScreen(
            imagesUrls: name!,
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/PlaceDetailsScreen':
        Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          child: PlaceDetailsScreen(
            place: map["place"],
            liked: map["liked"],
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/PlacesScreen':
        PlaceScreenType? type = settings.arguments as PlaceScreenType?;
        return PageTransition(
          child: PlacesScreen(screenType: type!),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/PlaceFormScreen':
        Map<String, dynamic>? args =
            settings.arguments as Map<String, dynamic>?;
        return PageTransition(
          child: PlaceFormScreen(
            place: args?['place'],
            details: args?['details'],
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/UploadPlaceImagesScreen':
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          child: UploadPlaceImagesScreen(
            placeModel: args['place']!,
            placeDetails: args['details'],
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/ForgotPasswordScreen':
        return PageTransition(
          child: ForgotPasswordScreen(),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );

      case '/QRViewScreen':
        return PageTransition(
          child: QRViewScreen(),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/onBoardingScreen':
        return PageTransition(
          child: OnBoardingScreen(),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/PlannerViewScreen':
        PlanModel? type = settings.arguments as PlanModel?;
        return PageTransition(
          child: PlannerViewScreen(planModel: type),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/PlanScreen':
        PlanModel? plans = settings.arguments as PlanModel?;
        return PageTransition(
          child: PlanScreen(planModel: plans),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/VideoScreen':
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          child: VideoScreen(
            url: args['url'],
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );
      case '/UpdatePlaceImagesScreen':
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          child: UpdatePlaceImagesScreen(
            placeModel: args['place'],
            placeDetails: args['details'],
          ),
          type: PageTransitionType.rightToLeft,
          duration: animationDuration,
          settings: settings,
        );

      default:
        return null;
    }
  }
}
