import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/error_object.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/data/collections_model.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:egypt_wonders/features/tripPlanner/repos/plan_reposatory.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

part 'plans_event.dart';
part 'plans_state.dart';

class PlansBloc extends Bloc<PlansEvent, PlansState> {
  late PlansRepository plansRepo;

  // Static method to get the instance of PlansBloc from the context
  static PlansBloc get(BuildContext context) =>
      BlocProvider.of<PlansBloc>(context);

  // Constructor
  PlansBloc({required this.plansRepo}) : super(PlansState()) {
    // Event handlers
    on<GetPlansEvent>(_onGetPlansEvent);
    on<AddPlanEvent>(_onAddPlanEvent);
    on<DeletePlanEvent>(_onDeletePlanEvent);
    on<AddCollectionEvent>(_onAddCollectionEvent);
    on<GetCollectionEvent>(_onGetCollectionEvent);
    on<DeleteCollectionEvent>(_onDeleteCollectionEvent);
  }

  // Event handler for fetching plans
  FutureOr<void> _onGetPlansEvent(
      GetPlansEvent event, Emitter<PlansState> emit) async {
    print("Executing _onGetPlansEvent"); // Logging
    print("Current state: ${state.toString()}"); // Logging
    emit(state.copyWith(plansStatus: RequestStatus.loading));
    final Either<FailureEntity, List<PlanModel>> plansEither =
        await plansRepo.getPlans(event.collectionId);
    plansEither.fold(
        (failure) => emit(state.copyWith(
            plansStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (plansList) {
      emit(
          state.copyWith(plansStatus: RequestStatus.success, plans: plansList));
      print("Success Getting Plans");
      print(plansList[0].placeName);
    });
  }

  // Event handler for adding a plan
  FutureOr<void> _onAddPlanEvent(
      AddPlanEvent event, Emitter<PlansState> emit) async {
    final Either<FailureEntity, bool> addEither =
        await plansRepo.addPlan(event.planModel);
    // You may emit the updated plans list here if necessary
  }

  // Event handler for adding a collection
  FutureOr<void> _onAddCollectionEvent(
      AddCollectionEvent event, Emitter<PlansState> emit) async {
    try {
      final Either<FailureEntity, bool> addEither =
          await plansRepo.addCollection(event.collectionModel);

      addEither.fold(
        (failure) {
          emit(state.copyWith(
            collectionStatus: RequestStatus.failure,
            errorObject: ErrorObject.mapFailureToErrorObject(failure: failure),
          ));
        },
        (added) {
          emit(state.copyWith(collectionStatus: RequestStatus.success));
          print("Collection Added");
        },
      );
    } catch (e) {
      // Handle exceptions if necessary
      print("Error adding collection: $e");
      emit(state.copyWith(
        collectionStatus: RequestStatus.failure,
        errorObject: ErrorObject(title: "Error", message: "$e"),
      ));
    }
  }

  // Event handler for fetching collections
  FutureOr<void> _onGetCollectionEvent(
      GetCollectionEvent event, Emitter<PlansState> emit) async {
    print("Executing _onGetPlansEvent"); // Logging
    print("Current state: ${state.toString()}"); // Logging
    emit(state.copyWith(collectionStatus: RequestStatus.loading));
    final Either<FailureEntity, List<CollectionModel>> collectionsEither =
        await plansRepo.getCollections();
    collectionsEither.fold(
        (failure) => emit(state.copyWith(
            collectionStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure))),
        (collectionsList) {
      emit(state.copyWith(
          collectionStatus: RequestStatus.success,
          collectionsList: collectionsList));
      // print("success Getting Plans");
    });
  }

  // Event handler for deleting a collection
  FutureOr<void> _onDeleteCollectionEvent(
      DeleteCollectionEvent event, Emitter<PlansState> emit) async {
    try {
      emit(state.copyWith(
        collectionDeleteStatus: RequestStatus.loading,
        deletingCollectionId: event.collectionId,
      ));

      final Either<FailureEntity, bool> result =
          await plansRepo.deleteCollection(event.collectionId);

      result.fold(
        (failure) {
          emit(state.copyWith(
            collectionDeleteStatus: RequestStatus.failure,
            deletingCollectionId: '',
            errorObject: ErrorObject(
              title: "Error",
              message: "Failed to delete collection: $failure",
            ),
          ));
        },
        (success) {
          if (success) {
            emit(state.copyWith(
              collectionDeleteStatus: RequestStatus.success,
              deletingCollectionId: '',
              // Optionally, you can remove the deleted collection from collectionsList
              collectionsList: state.collectionsList
                  .where((collection) => collection.id != event.collectionId)
                  .toList(),
            ));
            print("Collection Deleted");
          } else {
            emit(state.copyWith(
              collectionDeleteStatus: RequestStatus.failure,
              deletingCollectionId: '',
              errorObject: ErrorObject(
                title: "Error",
                message: "Failed to delete collection.",
              ),
            ));
          }
        },
      );
    } catch (e) {
      print("Error handling delete collection event: $e");
      emit(state.copyWith(
        collectionDeleteStatus: RequestStatus.failure,
        deletingCollectionId: '',
        errorObject: ErrorObject(title: "Error", message: "$e"),
      ));
    }
  }

  // Event handler for deleting a plan
  FutureOr<void> _onDeletePlanEvent(
      DeletePlanEvent event, Emitter<PlansState> emit) async {
    try {
      emit(state.copyWith(
        planDeleteStatus: RequestStatus.loading,
        deletingPlanId: event.planModel
            .id, // Replace with the appropriate field from the event object
      ));

      final Either<FailureEntity, bool> deleteEither = await plansRepo.deletePlan(
          plan: event
              .planModel); // Replace with the appropriate field from the event object

      deleteEither.fold(
        (failure) {
          emit(state.copyWith(
            collectionDeleteStatus: RequestStatus.failure,
            deletingCollectionId:
                '', // Replace with the appropriate field from the event object
            errorObject: ErrorObject(
              title: "Error",
              message: "Failed to delete plan: $failure",
            ),
          ));
        },
        (success) {
          if (success) {
            emit(state.copyWith(
              collectionDeleteStatus: RequestStatus.success,
              deletingCollectionId:
                  '', // Replace with the appropriate field from the event object
              // Optionally, you can update the plansList to remove the deleted plan
              plans: state.plans
                  .where((plan) => plan.id != event.planModel.id)
                  .toList(),
            ));
            print("Plan Deleted Successfully");
          } else {
            emit(state.copyWith(
              collectionDeleteStatus: RequestStatus.failure,
              deletingCollectionId:
                  '', // Replace with the appropriate field from the event object
              errorObject: ErrorObject(
                title: "Error",
                message: "Failed to delete plan.",
              ),
            ));
          }
        },
      );
    } catch (e) {
      print("Error handling delete plan event: $e");
      emit(state.copyWith(
        collectionDeleteStatus: RequestStatus.failure,
        deletingCollectionId:
            '', // Replace with the appropriate field from the event object
        errorObject: ErrorObject(title: "Error", message: "$e"),
      ));
    }
  }
}
