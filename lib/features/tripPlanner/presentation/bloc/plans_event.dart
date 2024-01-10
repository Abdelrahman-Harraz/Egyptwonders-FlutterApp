// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'plans_bloc.dart';

// PlansEvent serves as the base class for events in the plans_bloc.
class PlansEvent extends Equatable {
  const PlansEvent();

  @override
  List<Object> get props => [];
}

// GetPlansEvent represents the event of fetching plans for a specific collection.
class GetPlansEvent extends PlansEvent {
  final String collectionId;

  GetPlansEvent(
    this.collectionId,
  );

  @override
  List<Object> get props => [];
}

// AddPlanEvent represents the event of adding a plan to the collection.
class AddPlanEvent extends PlansEvent {
  final PlanModel planModel;

  const AddPlanEvent({
    required this.planModel,
  });

  @override
  List<Object> get props => [planModel];
}

// GetCollectionEvent represents the event of fetching collections.
class GetCollectionEvent extends PlansEvent {
  const GetCollectionEvent();

  @override
  List<Object> get props => [];
}

// AddCollectionEvent represents the event of adding a collection.
class AddCollectionEvent extends PlansEvent {
  final CollectionModel collectionModel;

  const AddCollectionEvent({
    required this.collectionModel,
  });

  @override
  List<Object> get props => [collectionModel];
}

// DeleteCollectionEvent represents the event of deleting a collection.
class DeleteCollectionEvent extends PlansEvent {
  final String collectionId;

  const DeleteCollectionEvent({
    required this.collectionId,
  });

  @override
  List<Object> get props => [collectionId];
}

// DeletePlanEvent represents the event of deleting a plan.
class DeletePlanEvent extends PlansEvent {
  final PlanModel planModel;

  DeletePlanEvent({
    required this.planModel,
  });

  @override
  List<Object> get props => [planModel];
}
