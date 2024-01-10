import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/error_object.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/data/reviews_model.dart';
import 'package:egypt_wonders/features/places/repo/places_repository.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  late PlacesRepository PlacesRepo;

  static PlacesBloc get(BuildContext context) =>
      BlocProvider.of<PlacesBloc>(context);

  PlacesBloc({required this.PlacesRepo}) : super(PlacesState()) {
    on<ResetPlacesEvent>(_onResetPlacesEvent);
    on<GetFavoretsPlacesEvent>(_onGetFavoretsPlacesEvent);
    on<GetVenuesEvent>(_onGetVenuesEvent);
    on<GetEventsAndActivitiesPlacesEvent>(_GetEventsAndActivitiesPlacesEvent);
    on<AddPlaceEvent>(_onAddPlaceEvent);
    on<RestAddingStatusEvent>(_onRestAddingStatusEvent);
    on<GetPlaceDetailsEvent>(_onGetPlaceDetailsEvent);
    on<GetplaceReviews>(_onGetplaceReviews);
    on<SearchPlaceByNameEvent>(_onSearchPlaceByNameEvent);
    on<DeletePlaceEvent>(_onDeletePlaceEvent);
    on<UpdatePlaceImagesEvent>(_onUpdatePlaceImagesEvent);
    on<ResetUpdatingStatusEvent>(_onResetUpdatingStatusEvent);
    on<UpdateCatigoryEvent>(_onUpdateCatigoryEvent);
  }

  FutureOr<void> _onResetPlacesEvent(
      ResetPlacesEvent event, Emitter<PlacesState> emit) {}

  FutureOr<void> _onGetFavoretsPlacesEvent(
      GetFavoretsPlacesEvent event, Emitter<PlacesState> emit) async {
    print("Getting Favorets");
    emit(state.copyWith(favoritsEventsStatus: RequestStatus.loading));
    final Either<FailureEntity, List<PlaceModel>> eventsEither =
        await PlacesRepo.getPlacesEvents(event.types);
    eventsEither.fold(
        (failure) => emit(state.copyWith(
            favoritsEventsStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (eventsList) {
      emit(state.copyWith(
          favoritsEventsStatus: RequestStatus.success,
          favoritsEventsList: eventsList));
      print(state.favoritsPlacesList.toString());
    });
  }

  FutureOr<void> _GetEventsAndActivitiesPlacesEvent(
      GetEventsAndActivitiesPlacesEvent event,
      Emitter<PlacesState> emit) async {
    print("Getting EventsAndActivities");
    emit(state.copyWith(
        GetEventsAndActivitiesPlacesEventStatus: RequestStatus.loading));
    final Either<FailureEntity, List<PlaceModel>>
        GetEventsAndActivitiesPlacesEthier = await PlacesRepo.getPlaces(
            event.types, PlaceScreenType.eventsAndActivities);
    GetEventsAndActivitiesPlacesEthier.fold(
        (failure) => emit(state.copyWith(
            GetEventsAndActivitiesPlacesEventStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (eventsList) {
      emit(state.copyWith(
          GetEventsAndActivitiesPlacesEventStatus: RequestStatus.success,
          EventsAndActivitiesList: eventsList));
      print("success Getting EventsAndActivities");
    });
  }

  FutureOr<void> _onGetVenuesEvent(
      GetVenuesEvent event, Emitter<PlacesState> emit) async {
    print("Getting Popular");
    emit(state.copyWith(venuesStatus: RequestStatus.loading));
    final Either<FailureEntity, List<PlaceModel>> venuesEthier =
        await PlacesRepo.getPlaces(event.types, PlaceScreenType.venues);
    venuesEthier.fold(
        (failure) => emit(state.copyWith(
            venuesStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (placesList) {
      emit(state.copyWith(
          venuesStatus: RequestStatus.success, venuesList: placesList));
      print("success Getting Popular");
      //print(state.popularEventsList.toString());
    });
  }

  FutureOr<void> _onAddPlaceEvent(
      AddPlaceEvent event, Emitter<PlacesState> emit) async {
    emit(state.copyWith(addEventStatus: RequestStatus.loading));
    final Either<FailureEntity, bool> addEither = await PlacesRepo.createPlace(
      place: event.placeModel,
      placeDetails: event.placeDetailsModel,
      coverImageUrl: event.coverImageUrl,
      placeImages: event.placeImages,
      galleryImages: event.galleryImages,
    );
    addEither.fold(
      (failure) {
        emit(state.copyWith(
            addEventStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (added) {
        emit(state.copyWith(addEventStatus: RequestStatus.success));
        print("Event Added");
      },
    );
  }

  FutureOr<void> _onRestAddingStatusEvent(
      RestAddingStatusEvent event, Emitter<PlacesState> emit) {
    emit(state.copyWith(addEventStatus: RequestStatus.initial));
  }

  FutureOr<void> _onGetPlaceDetailsEvent(
      GetPlaceDetailsEvent event, Emitter<PlacesState> emit) async {
    print("Getting Details");
    emit(state.copyWith(selectedEventStatus: RequestStatus.loading));
    final Either<FailureEntity, PlaceDetailsModel> eventDetailsEthier =
        await PlacesRepo.getPlaceDetails(event.event);
    eventDetailsEthier.fold(
        (failure) => emit(state.copyWith(
            selectedEventStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (details) {
      emit(state.copyWith(
          selectedEventStatus: RequestStatus.success,
          selectedEventDetails: details));
      print("success Getting Details");
      print(state.selectedPlacesDetails.toString());
    });
  }

  FutureOr<void> _onGetplaceReviews(
      GetplaceReviews event, Emitter<PlacesState> emit) async {
    print("Getting Details");
    emit(state.copyWith(selectedEventStatus: RequestStatus.loading));
    final List<Review>? results =
        await PlacesRepo.getplaceReviews(event.placeId);
    emit(state.copyWith(selectedPlaceReviews: results));
  }

  FutureOr<void> _onSearchPlaceByNameEvent(
      SearchPlaceByNameEvent event, Emitter<PlacesState> emit) async {
    print("Searching ...");
    emit(state.copyWith(searchEventsStatus: RequestStatus.loading));
    final Either<FailureEntity, List<PlaceModel>> searchEthier =
        await PlacesRepo.searchPlacesByName(event.query, []);
    searchEthier.fold(
        (failure) => emit(state.copyWith(
            searchEventsStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (eventsList) {
      emit(state.copyWith(
          searchEventsStatus: RequestStatus.success,
          searchEventsList: eventsList));
      print("Success Searching");
      print(state.searchPlacesList.toString());
    });
  }

  FutureOr<void> _onDeletePlaceEvent(
      DeletePlaceEvent event, Emitter<PlacesState> emit) async {
    final Either<FailureEntity, bool> deleteEthier =
        await PlacesRepo.deletePlace(
            place: event.placeModel, details: event.detailsModel);
    deleteEthier.fold(
        (failure) => Fluttertoast.showToast(
              msg: "Error in Delete",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 1,
              backgroundColor: OwnTheme.secondaryColor,
              textColor: Colors.white,
              fontSize: 14.sp,
            ), (eventsList) {
      Fluttertoast.showToast(
        msg: "Event Deleted Successfully",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        backgroundColor: OwnTheme.secondaryColor,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
    });
  }

  FutureOr<void> _onUpdatePlaceImagesEvent(
      UpdatePlaceImagesEvent event, Emitter<PlacesState> emit) async {
    emit(state.copyWith(updateEventStatus: RequestStatus.loading));
    final Either<FailureEntity, bool> updateEither =
        await PlacesRepo.updatePlaceImages(
      place: event.placeModel,
      placeDetails: event.detailsModel,
      coverImageUrl: event.coverImageUrl,
      placeImages: event.placeImages,
      galleryImages: event.galleryImages,
      // organizerImageUrl: event.organizerImageUrl,
      deleted: event.deletedImages,
    );
    updateEither.fold(
      (failure) {
        emit(state.copyWith(
            updateEventStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (updated) {
        emit(state.copyWith(updateEventStatus: RequestStatus.success));
        print("Event Images Updated");
      },
    );
  }

  FutureOr<void> _onResetUpdatingStatusEvent(
      ResetUpdatingStatusEvent event, Emitter<PlacesState> emit) {
    emit(state.copyWith(updateEventStatus: RequestStatus.initial));
  }

  FutureOr<void> _onUpdateCatigoryEvent(
      UpdateCatigoryEvent event, Emitter<PlacesState> emit) {
    switch (event.screenType) {
      case PlaceScreenType.venues:
        List<PlaceCategory> temp = [];
        temp.addAll(state.selectedVenuesCatigories);
        if (state.selectedVenuesCatigories.contains(event.category)) {
          temp.remove(event.category);
        } else {
          temp.add(event.category);
        }
        emit(state.copyWith(selectedVenuesCatigories: temp));
        break;
      case PlaceScreenType.eventsAndActivities:
        List<PlaceCategory> temp = [];
        temp.addAll(state.selectedEventsAndActivitiesCatigories);
        if (state.selectedEventsAndActivitiesCatigories
            .contains(event.category)) {
          temp.remove(event.category);
        } else {
          temp.add(event.category);
        }
        emit(state.copyWith(selectedEventsAndActivitiesCatigories: temp));
        break;
      case PlaceScreenType.favorite:
        List<PlaceCategory> temp = [];
        temp.addAll(state.scelectedFavoritCatigories);
        if (state.scelectedFavoritCatigories.contains(event.category)) {
          temp.remove(event.category);
        } else {
          temp.add(event.category);
        }
        emit(state.copyWith(scelectedFavoritCatigories: temp));
        break;
      case PlaceScreenType.search:
        List<PlaceCategory> temp = [];
        temp.addAll(state.scelectedSearchCatigories);
        if (state.scelectedSearchCatigories.contains(event.category)) {
          temp.remove(event.category);
        } else {
          temp.add(event.category);
        }
        emit(state.copyWith(scelectedSearchCatigories: temp));
        break;
    }
  }
}
