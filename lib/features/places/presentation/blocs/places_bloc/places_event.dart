// places_bloc.dart

part of 'places_bloc.dart';

// Abstract class representing events related to Places
abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object> get props => [];
}

// ResetPlacesEvent: Event to reset places
class ResetPlacesEvent extends PlacesEvent {}

// GetVenuesEvent: Event to get venues with specified types
class GetVenuesEvent extends PlacesEvent {
  final List<String> types;
  const GetVenuesEvent(this.types);

  @override
  List<Object> get props => [types];
}

// GetPlaceDetailsEvent: Event to get details of a specific place
class GetPlaceDetailsEvent extends PlacesEvent {
  final PlaceModel event;
  const GetPlaceDetailsEvent(this.event);

  @override
  List<Object> get props => [event];
}

// GetplaceReviews: Event to get reviews of a place with specified ID
class GetplaceReviews extends PlacesEvent {
  final String placeId;
  const GetplaceReviews(this.placeId);

  @override
  List<Object> get props => [placeId];
}

// GetEventsAndActivitiesPlacesEvent: Event to get events and activities with specified types
class GetEventsAndActivitiesPlacesEvent extends PlacesEvent {
  final List<String> types;
  const GetEventsAndActivitiesPlacesEvent(this.types);

  @override
  List<Object> get props => [types];
}

// RestAddingStatusEvent: Event to reset the status of adding a place
class RestAddingStatusEvent extends PlacesEvent {}

// AddPlaceEvent: Event to add a new place
class AddPlaceEvent extends PlacesEvent {
  final PlaceModel placeModel;
  final PlaceDetailsModel placeDetailsModel;
  final List<File> placeImages;
  final List<File> coverImageUrl;
  final List<File> galleryImages;

  const AddPlaceEvent({
    required this.placeModel,
    required this.placeDetailsModel,
    required this.placeImages,
    required this.coverImageUrl,
    required this.galleryImages,
  });

  @override
  List<Object> get props => [
        placeModel,
        placeDetailsModel,
        placeImages,
        coverImageUrl,
        galleryImages,
      ];
}

// GetFavoretsPlacesEvent: Event to get favorite places with specified types
class GetFavoretsPlacesEvent extends PlacesEvent {
  final List<String> types;

  const GetFavoretsPlacesEvent(
    this.types,
  );

  @override
  List<Object> get props => [types];
}

// SearchPlaceByNameEvent: Event to search places by name with a specified query
class SearchPlaceByNameEvent extends PlacesEvent {
  final String query;

  const SearchPlaceByNameEvent(this.query);

  @override
  List<Object> get props => [query];
}

// DeletePlaceEvent: Event to delete a place
class DeletePlaceEvent extends PlacesEvent {
  final PlaceModel placeModel;
  final PlaceDetailsModel detailsModel;
  const DeletePlaceEvent(this.placeModel, this.detailsModel);

  @override
  List<Object> get props => [placeModel, detailsModel];
}

// UpdatePlaceImagesEvent: Event to update images of a place
class UpdatePlaceImagesEvent extends PlacesEvent {
  final PlaceModel placeModel;
  final PlaceDetailsModel detailsModel;
  final List<dynamic> placeImages;
  final List<dynamic> coverImageUrl;
  final List<dynamic> galleryImages;

  final List<String> deletedImages;
  const UpdatePlaceImagesEvent({
    required this.placeModel,
    required this.detailsModel,
    required this.placeImages,
    required this.coverImageUrl,
    required this.galleryImages,
    required this.deletedImages,
  });

  @override
  List<Object> get props => [
        placeModel,
        detailsModel,
        placeImages,
        coverImageUrl,
        galleryImages,
        deletedImages
      ];
}

// ResetUpdatingStatusEvent: Event to reset the status of updating a place
class ResetUpdatingStatusEvent extends PlacesEvent {}

// UpdateCatigoryEvent: Event to update the category of a place
class UpdateCatigoryEvent extends PlacesEvent {
  final PlaceScreenType screenType;
  final PlaceCategory category;
  const UpdateCatigoryEvent(this.screenType, this.category);

  @override
  List<Object> get props => [screenType, category];
}
