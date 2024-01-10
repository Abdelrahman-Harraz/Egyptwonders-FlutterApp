import 'dart:async';
import 'dart:io';

import 'package:egypt_wonders/core/main_blocs/repositories_providers.dart';
import 'package:egypt_wonders/environment.dart';
import 'package:egypt_wonders/features/common/presentation/bloc/app_status/bloc/app_status_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/root.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/main_blocs/bloc_providers.dart';
import 'core/utililty/routes/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'core/utililty/storage/shared_preferences.dart';

// Navigate to page without context 
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// Entry point of the application
Future<void> main() async {
  // Set up error handling for the entire application
  runZonedGuarded(() async {
    // Ensure that widgets are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Set preferred screen orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // Initialize shared preferences
    await SharedPref.init();

    // Run the application
    runApp(const MyApp());
  }, (exception, stackTrace) async {});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set system overlay styles
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    // Wrap the entire application with repository and bloc providers
    return MultiRepositoryProvider(
      providers: RepositoriesProviders.providers,
      child: MultiBlocProvider(
        providers: BlocProviders.providers,
        child: Builder(builder: (context) {
          // Trigger AppStartedEvent to initialize app status
          AppStatusBloc.get(context).add(AppStartedEvent());

          // Configure the application layout based on device size
          return Sizer(
            builder: (context, orientation, deviceType) {
              // Add a gesture detector to handle taps outside of input fields
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // Unfocus the current focus when tapping outside input fields
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                },
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Egypt Wonders',
                  theme: OwnTheme.themeData(),
                  onGenerateRoute: AppRouter.onGenerateRoute,
                  home: Builder(builder: (context) {
                    // Return the appropriate root widget based on app mode
                    return Environment.appMode == AppMode.live
                        ? const Root()
                        : const Root();
                  }),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
