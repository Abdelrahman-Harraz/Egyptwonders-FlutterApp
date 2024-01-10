// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_cached_img.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/bloc/plans_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/widgets/places_planner_card.dart';
import 'package:egypt_wonders/theme.dart';

class PlanScreen extends StatefulWidget {
  PlanModel? planModel;
  PlanScreen({
    Key? key,
    required this.planModel,
  }) : super(key: key);
  static const routeName = "/PlanScreen";

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(txt: "All Plans"),
      body: SingleChildScrollView(
        child: BlocBuilder<PlansBloc, PlansState>(
          builder: (context, state) {
            if (state.plansStatus == RequestStatus.loading) {
              return LoadingWidget();
            } else {
              return state.plans.isNotEmpty
                  ? Column(
                      children: state.plans
                          .map((e) => TripContainer(plans: e))
                          .toList(),
                    )
                  : Center(child: Text("Empty"));
            }
          },
        ),
      ),
    );
  }
}

class TripContainer extends StatefulWidget {
  PlanModel? plans;
  TripContainer({
    Key? key,
    required this.plans,
  }) : super(key: key);

  @override
  _TripContainerState createState() => _TripContainerState();
}

class _TripContainerState extends State<TripContainer> {
  late DateTime _focusDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _focusDate = DateTime.now();

    // Initialize selected date and time from the PlanModel
    _selectedTime = widget.plans!.time != null
        ? TimeOfDay.fromDateTime(widget.plans!.time!)
        : null;

    _selectedDate = widget.plans!.day;
  }

  // Function to handle time selection
  Future<void> _selectTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
      print("Selected time: ${selectedTime.format(context)}");

      // Convert TimeOfDay to DateTime
      DateTime selectedDateTime = DateTime(
        _focusDate.year,
        _focusDate.month,
        _focusDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Update the PlanModel with the selected time
      widget.plans = widget.plans!.copyWith(time: selectedDateTime);

      // Update the PlanModel in Firestore
      await FirebaseRepo.updatePlanInFirestore(widget.plans!);
    }
  }

  // Function to handle date selection
  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      print("Selected date: ${selectedDate.toLocal()}");

      // Update the PlanModel with the selected date
      widget.plans = widget.plans!.copyWith(day: selectedDate);

      // Update the PlanModel in Firestore
      await FirebaseRepo.updatePlanInFirestore(widget.plans!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: OwnTheme.black),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlacesPlannerCard(
                  plans: PlanModel(
                    placeCoverImage: widget.plans!.placeCoverImage,
                    placeName: widget.plans!.placeName,
                    city: widget.plans!.city,
                  ),
                ),
                SizedBox(width: paddingAll),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: side1),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: _selectTime,
                            ),
                            if (_selectedTime != null)
                              Text(
                                _selectedTime!.format(context),
                                style: TextStyle(fontSize: 16),
                              ),
                            if (_selectedTime == null)
                              Text(
                                "Select trip time",
                                style: TextStyle(fontSize: 16),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: _selectDate,
                          ),
                          if (_selectedDate != null)
                            Text(
                              DateFormat.yMd().format(_selectedDate!),
                              style: TextStyle(fontSize: 16),
                            ),
                          if (_selectedDate == null)
                            Text(
                              "Select trip date",
                              style: TextStyle(fontSize: 16),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {
                PlansBloc.get(context)
                    .add(DeletePlanEvent(planModel: widget.plans!));
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
