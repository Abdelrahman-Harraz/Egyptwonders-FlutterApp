part of 'home_bloc.dart';

// Class representing the state of the HomeBloc
class HomeState extends Equatable {
  // Current selected tab
  final HomeTab tab;

  // Constructor to initialize the state with a default tab value
  const HomeState({
    this.tab = HomeTab.home,
  });

  // Method to create a copy of the current state with optional parameter changes
  HomeState copyWith({
    HomeTab? tab,
  }) {
    return HomeState(
      tab: tab ?? this.tab,
    );
  }

  // Override the Equatable props list to enable state comparison
  @override
  List<Object> get props => [tab];
}
