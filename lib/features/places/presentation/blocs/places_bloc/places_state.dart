// places_bloc.dart

part of 'places_bloc.dart';

// PlacesState: Represents the state of the PlacesBloc
class PlacesState extends Equatable {
  // Lists to hold different types of places and categories
  List<PlaceModel> venuesList;
  List<PlaceModel> favoritsPlacesList;
  List<PlaceModel> searchPlacesList;
  List<PlaceModel> eventsAndActivitiesList;
  List<PlaceCategory> selectedEventsAndActivitiesCatigories;
  List<Review> selectedPlaceReviews;
  List<PlaceCategory> selectedVenuesCatigories;
  List<PlaceCategory> scelectedFavoritCatigories;
  List<PlaceCategory> scelectedSearchCatigories;

  // Status indicators for different types of requests
  RequestStatus eventsAndActivitiesStatus;
  RequestStatus venuesStatus;
  RequestStatus favoritsPlacesStatus;
  RequestStatus searchPlacesStatus;
  RequestStatus selectedPlacesStatus;
  RequestStatus addPlacesStatus;
  RequestStatus updatePlacesStatus;

  // Error information
  ErrorObject errorObject;

  // Details of the selected place
  PlaceDetailsModel selectedPlacesDetails;

  // Constructor with default values
  PlacesState({
    this.favoritsPlacesList = const [],
    this.eventsAndActivitiesList = const [],
    this.searchPlacesList = const [],
    this.venuesList = const [],
    this.scelectedFavoritCatigories = const [],
    this.selectedPlaceReviews = const [],
    this.selectedEventsAndActivitiesCatigories = const [],
    this.selectedVenuesCatigories = const [],
    this.scelectedSearchCatigories = const [],
    this.eventsAndActivitiesStatus = RequestStatus.initial,
    this.venuesStatus = RequestStatus.initial,
    this.favoritsPlacesStatus = RequestStatus.initial,
    this.searchPlacesStatus = RequestStatus.initial,
    this.selectedPlacesStatus = RequestStatus.initial,
    this.addPlacesStatus = RequestStatus.initial,
    this.updatePlacesStatus = RequestStatus.initial,
    this.selectedPlacesDetails = const PlaceDetailsModel(),
    this.errorObject = const ErrorObject(title: "", message: ""),
  });

  // CopyWith method to create a copy of the current state with optional changes
  PlacesState copyWith({
    RequestStatus? GetEventsAndActivitiesPlacesEventStatus,
    RequestStatus? venuesStatus,
    RequestStatus? favoritsEventsStatus,
    RequestStatus? searchEventsStatus,
    RequestStatus? selectedEventStatus,
    RequestStatus? addEventStatus,
    RequestStatus? updateEventStatus,
    List<PlaceModel>? venuesList,
    List<PlaceModel>? EventsAndActivitiesList,
    List<PlaceModel>? favoritsEventsList,
    List<PlaceModel>? searchEventsList,
    PlaceDetailsModel? selectedEventDetails,
    List<PlaceCategory>? selectedEventsAndActivitiesCatigories,
    List<Review>? selectedPlaceReviews,
    List<PlaceCategory>? selectedVenuesCatigories,
    List<PlaceCategory>? scelectedFavoritCatigories,
    List<PlaceCategory>? scelectedSearchCatigories,
    ErrorObject? errorObject,
  }) {
    return PlacesState(
      // If the parameter is not null, use its value, otherwise use the current state's value
      eventsAndActivitiesStatus: GetEventsAndActivitiesPlacesEventStatus ??
          this.eventsAndActivitiesStatus,
      addPlacesStatus: addEventStatus ?? this.addPlacesStatus,
      updatePlacesStatus: updateEventStatus ?? this.updatePlacesStatus,
      venuesStatus: venuesStatus ?? this.venuesStatus,
      favoritsPlacesStatus: favoritsEventsStatus ?? this.favoritsPlacesStatus,
      searchPlacesStatus: searchEventsStatus ?? this.searchPlacesStatus,
      scelectedFavoritCatigories:
          scelectedFavoritCatigories ?? this.scelectedFavoritCatigories,
      selectedPlaceReviews: selectedPlaceReviews ?? this.selectedPlaceReviews,
      selectedEventsAndActivitiesCatigories:
          selectedEventsAndActivitiesCatigories ??
              this.selectedEventsAndActivitiesCatigories,
      selectedVenuesCatigories:
          selectedVenuesCatigories ?? this.selectedVenuesCatigories,
      scelectedSearchCatigories:
          scelectedSearchCatigories ?? this.scelectedSearchCatigories,
      selectedPlacesStatus: selectedEventStatus ?? this.selectedPlacesStatus,
      errorObject: errorObject ?? this.errorObject,
      favoritsPlacesList: favoritsEventsList ?? this.favoritsPlacesList,
      eventsAndActivitiesList:
          EventsAndActivitiesList ?? this.eventsAndActivitiesList,
      venuesList: venuesList ?? this.venuesList,
      searchPlacesList: searchEventsList ?? this.searchPlacesList,
      selectedPlacesDetails: selectedEventDetails ?? this.selectedPlacesDetails,
    );
  }

  // Override Equatable's props getter to include all the fields for equality comparison
  @override
  List<Object> get props => [
        errorObject,
        venuesStatus,
        eventsAndActivitiesStatus,
        favoritsPlacesStatus,
        selectedPlacesStatus,
        searchPlacesStatus,
        favoritsPlacesList,
        addPlacesStatus,
        eventsAndActivitiesList,
        searchPlacesList,
        venuesList,
        selectedPlacesDetails,
        selectedPlaceReviews,
        updatePlacesStatus,
        scelectedFavoritCatigories,
        selectedEventsAndActivitiesCatigories,
        selectedVenuesCatigories,
        scelectedSearchCatigories
      ];
}
