// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'plans_bloc.dart';

// PlansState represents the state of the plans_bloc, including various lists, statuses, and error information.
class PlansState extends Equatable {
  List<PlanModel> plans;
  List<CollectionModel> collectionsList;
  RequestStatus plansStatus;
  RequestStatus collectionStatus;
  ErrorObject errorObject;
  RequestStatus collectionDeleteStatus;
  RequestStatus planDeleteStatus;
  String deletingPlanId;
  String deletingCollectionId;

  PlansState({
    this.plans = const [],
    this.collectionsList = const [],
    this.plansStatus = RequestStatus.initial,
    this.collectionStatus = RequestStatus.initial,
    this.collectionDeleteStatus = RequestStatus.initial,
    this.planDeleteStatus = RequestStatus.initial,
    this.deletingCollectionId = '',
    this.deletingPlanId = '',
    this.errorObject = const ErrorObject(title: "", message: ""),
  });

  @override
  List<Object> get props {
    return [
      plans,
      collectionsList,
      plansStatus,
      collectionStatus,
      collectionDeleteStatus,
      planDeleteStatus,
      deletingCollectionId,
      deletingPlanId,
      errorObject,
    ];
  }

  // copyWith creates a new instance of PlansState with optional updated values.
  PlansState copyWith({
    List<PlanModel>? plans,
    List<CollectionModel>? collectionsList,
    RequestStatus? plansStatus,
    RequestStatus? collectionStatus,
    RequestStatus? planDeleteStatus,
    RequestStatus? collectionDeleteStatus,
    String? deletingCollectionId,
    String? deletingPlanId,
    ErrorObject? errorObject,
  }) {
    return PlansState(
      plans: plans ?? this.plans,
      collectionsList: collectionsList ?? this.collectionsList,
      plansStatus: plansStatus ?? this.plansStatus,
      collectionStatus: collectionStatus ?? this.collectionStatus,
      planDeleteStatus: planDeleteStatus ?? this.planDeleteStatus,
      collectionDeleteStatus:
          collectionDeleteStatus ?? this.collectionDeleteStatus,
      deletingCollectionId: deletingCollectionId ?? this.deletingCollectionId,
      deletingPlanId: deletingPlanId ?? this.deletingPlanId,
      errorObject: errorObject ?? this.errorObject,
    );
  }
}
