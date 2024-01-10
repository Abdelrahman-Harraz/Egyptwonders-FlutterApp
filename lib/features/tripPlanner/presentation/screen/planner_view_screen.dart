// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_details.dart';
import 'package:egypt_wonders/features/tripPlanner/data/collections_model.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/bloc/plans_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/screen/plan_Screen.dart';

// PlannerViewScreen: Screen for viewing and managing trip plans
class PlannerViewScreen extends StatefulWidget {
  PlanModel? planModel;
  PlannerViewScreen({
    Key? key,
    this.planModel,
  }) : super(key: key);
  static const routeName = "/PlannerViewScreen";

  @override
  _PlannerViewScreenState createState() => _PlannerViewScreenState();
}

// _PlannerViewScreenState: State class for PlannerViewScreen
class _PlannerViewScreenState extends State<PlannerViewScreen> {
  List<String> planNames = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadPlanNames();
  }

  // Load plan names from SharedPreferences
  Future<void> _loadPlanNames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      planNames = prefs.getStringList('planNames') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: widget.planModel != null
            ? const Text("Select Plan")
            : const Text("Planner"),
        actions: [
          IconButton(
            onPressed: () {
              _showPlanInputDialog(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<PlansBloc, PlansState>(
            builder: (context, state) {
              if (state.collectionStatus == RequestStatus.success) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: state.collectionsList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final collection =
                        state.collectionsList.reversed.toList()[index];
                    return _buildPlanContainer(
                      collection.name,
                      collection.id!,
                      collection.dateAdded,
                      collection.backgroundImagePath,
                    );
                  },
                );
              } else {
                return const LoadingWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  // Build the UI for an individual plan container
  Widget _buildPlanContainer(String? planName, String collectionId,
      DateTime? dateAdded, String? backgroundImagePath) {
    return GestureDetector(
      onTap: () {
        if (widget.planModel != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text("Add To $planName")),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(paddingAll),
                          child: ElevatedButton(
                            onPressed: () {
                              PlansBloc.get(context).add(AddPlanEvent(
                                planModel: widget.planModel!
                                    .copyWith(collectionId: collectionId),
                              ));
                              Navigator.popUntil(
                                context,
                                (route) =>
                                    route.settings.name ==
                                    PlaceDetailsScreen.routeName,
                              );
                            },
                            child: const Text("Yes"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          PlansBloc.get(context).add(GetPlansEvent(collectionId));
          Navigator.pushNamed(
            context,
            PlanScreen.routeName,
          );
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: backgroundImagePath != null ? null : OwnTheme.primaryColor,
              borderRadius: BorderRadius.circular(14),
              image: backgroundImagePath != null
                  ? DecorationImage(
                      image: FileImage(File(backgroundImagePath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Positioned(
            top: 9.0,
            right: 8.0,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: OwnTheme.black,
              ),
              onPressed: () {
                PlansBloc.get(context)
                    .add(DeleteCollectionEvent(collectionId: collectionId));
              },
            ),
          ),
          Positioned(
            bottom: 7,
            left: 8,
            child: Opacity(
              opacity: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: OwnTheme.grey,
                ),
                height: 7.h,
                width: 40.1.w,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planName ?? "Plan name",
                        style: OwnTheme.bodyTextStyle().copyWith(
                            color: OwnTheme.black, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (dateAdded != null)
                        Text(
                          "Created: ${DateFormat('dd-MM-yyyy').format(dateAdded)}",
                          style: OwnTheme.datestyle().copyWith(
                              color: OwnTheme.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show a dialog for adding a new plan
  Future<void> _showPlanInputDialog(BuildContext context) async {
    String planName = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: AlertDialog(
                title: const Center(child: Text('New Tour Plan')),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24.0,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final imagePicker = ImagePicker();
                          final pickedFile = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            setState(() {
                              _selectedImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(paddingAll),
                          child: Container(
                            width: 40.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                              image: _selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _selectedImage == null
                                ? Column(
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: OwnTheme.callToActionColor),
                                      Text(
                                        "Add Background Image",
                                        style: OwnTheme.datestyle().copyWith(
                                            color: OwnTheme.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          planName = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter plan name...',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (planName.isEmpty) {
                        planName = 'Plan name';
                      }

                      final collectionModel = CollectionModel(
                        name: planName,
                        dateAdded: DateTime.now(),
                        backgroundImagePath: _selectedImage?.path,
                      );

                      PlansBloc.get(context).add(AddCollectionEvent(
                        collectionModel: collectionModel,
                      ));
                      await Future.delayed(const Duration(seconds: 2));
                      PlansBloc.get(context).add(const GetCollectionEvent());
                      setState(() {
                        _selectedImage = null;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
