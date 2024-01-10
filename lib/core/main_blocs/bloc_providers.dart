import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/auth/repos/auth_repository.dart';
import 'package:egypt_wonders/features/common/presentation/bloc/app_status/bloc/app_status_bloc.dart';
import 'package:egypt_wonders/features/common/repos/app_status_repository.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/places/repo/places_repository.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/bloc/plans_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/repos/plan_reposatory.dart';

import 'blocs.dart';

// A class responsible for providing instances of various BLoCs in the application
class BlocProviders {
  // List of BLoC providers for dependency injection
  static final List<BlocProvider> providers = [
    // AppStatusBloc provider with dependencies injected
    BlocProvider<AppStatusBloc>(
        create: (context) => AppStatusBloc(
            appStatusRepo: RepositoryProvider.of<AppStatusRepository>(context),
            authRepo: RepositoryProvider.of<AuthRepository>(context))),

    // AuthBloc provider with dependencies injected
    BlocProvider<AuthBloc>(
        create: (context) =>
            AuthBloc(authRepo: RepositoryProvider.of<AuthRepository>(context))),

    // PlacesBloc provider with dependencies injected
    BlocProvider<PlacesBloc>(
        create: (context) => PlacesBloc(
            PlacesRepo: RepositoryProvider.of<PlacesRepository>(context))),

    // PlansBloc provider with dependencies injected
    BlocProvider<PlansBloc>(
        create: (context) => PlansBloc(
            plansRepo: RepositoryProvider.of<PlansRepository>(context))),

    // HomeBloc provider without explicit dependencies
    BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
  ];
}
