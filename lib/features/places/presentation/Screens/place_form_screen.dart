import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/core/utililty/validations/percise_validation.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
// import 'package:egypt_wonders/features/auth/presentaion/widgets/field_decoration.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/field_decoration.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/time_pickers.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/upload_images_screen.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PlaceFormScreen extends StatefulWidget {
  static String routeName = "/PlaceFormScreen";
  PlaceModel? place;
  PlaceDetailsModel? details;
  PlaceFormScreen({super.key, this.place, this.details});

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final nameFocusNode = FocusNode();
  final typeFocusNode = FocusNode();
  final aboutFocusNode = FocusNode();
  final dayOffFocusNode = FocusNode();
  final endDayFocusNode = FocusNode();
  final startHourFocusNode = FocusNode();
  final endHourFocusNode = FocusNode();
  final urlFocusNode = FocusNode();
  final buildingFocusNode = FocusNode();
  final streetFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final governmentFocusNode = FocusNode();
  final lowPriceFocusNode = FocusNode();
  final highPriceFocusNode = FocusNode();
  final currencyFocusNode = FocusNode();
  final startDayNameFocusNode = FocusNode();
  final endDayNameFocusNode = FocusNode();

  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String? selectedOffDay;
  String? selectedEndDay;

  // DateTime _selectedStartDate = DateTime.now();
  // DateTime _selectedEndDate = DateTime.now();

  String? slectedPlaceType;
  bool isVenue = false;
  bool isEventsAndActivities = false;

  bool isScan = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController dayOffController = TextEditingController();
  final TextEditingController endDayController = TextEditingController();
  final TextEditingController endHourController = TextEditingController();
  final TextEditingController startHourController = TextEditingController();
  final TextEditingController lowPriceController = TextEditingController();
  final TextEditingController highPriceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController goventmentController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController startDayNameController = TextEditingController();
  final TextEditingController endDayNameController = TextEditingController();
  // final TextEditingController organizerNameController = TextEditingController();

  TimeOfDay? startHour;

  TimeOfDay? endHour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.place != null && widget.details != null) {
      setState(() {
        isVenue = widget.place!.isVenue ?? false;
        isEventsAndActivities = widget.place!.isEventsAndActivities ?? false;
        isScan = widget.place!.isScan ?? false;
        slectedPlaceType = widget.place!.type;
        nameController.text = widget.place!.name ?? "";
        selectedOffDay = widget.place!.dayOffName ?? "";
        selectedEndDay = widget.place!.endDayName ?? "";
        urlController.text = widget.details!.url ?? "";
        aboutController.text = widget.details!.about ?? "";
        dayOffController.text = widget.place!.startDay != null
            ? DateFormat('dd').format(widget.place!.startDay!)
            : "";
        endDayController.text = widget.place!.endDay != null
            ? DateFormat('dd').format(widget.place!.endDay!)
            : "";
        startHourController.text = widget.place!.startHour != null
            ? "${widget.place!.startHour!.hour} : ${widget.place!.startHour!.minute}"
            : "";
        startHour = TimeOfDay.fromDateTime(widget.place!.startHour != null
            ? widget.place!.startHour!
            : DateTime.now());
        endHourController.text = widget.place!.endHour != null
            ? "${widget.place!.endHour!.hour} : ${widget.place!.endHour!.minute}"
            : "";
        endHour = TimeOfDay.fromDateTime(widget.place!.endHour != null
            ? widget.place!.endHour!
            : DateTime.now());
        lowPriceController.text = widget.details!.lowPrice?.toString() ?? "";
        highPriceController.text = widget.details!.highPrice?.toString() ?? "";
        currencyController.text = widget.details!.currency ?? "";
        buildingController.text = widget.place!.buildingNumber ?? "";
        streetController.text = widget.place!.streetName ?? "";
        cityController.text = widget.place!.city ?? "";
        goventmentController.text = widget.place!.governorate ?? "";
        countryController.text = widget.place!.country ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(txt: "Place"),
      backgroundColor: OwnTheme.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Venue :",
                      style: OwnTheme.bodyTextStyle()
                          .copyWith(color: OwnTheme.black),
                    ),
                    Checkbox(
                      checkColor: OwnTheme.black,
                      fillColor: MaterialStateProperty.all(OwnTheme.white),
                      value: isVenue,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: OwnTheme.black),
                          borderRadius: BorderRadius.circular(5)),
                      onChanged: (bool? value) {
                        setState(() {
                          isVenue = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      "E&A :",
                      style: OwnTheme.bodyTextStyle()
                          .copyWith(color: OwnTheme.black),
                    ),
                    Checkbox(
                      checkColor: OwnTheme.black,
                      fillColor: MaterialStateProperty.all(OwnTheme.white),
                      value: isEventsAndActivities,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: OwnTheme.black),
                          borderRadius: BorderRadius.circular(5)),
                      onChanged: (bool? value) {
                        setState(() {
                          isEventsAndActivities = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      "Scan :",
                      style: OwnTheme.bodyTextStyle()
                          .copyWith(color: OwnTheme.black),
                    ),
                    Checkbox(
                      checkColor: OwnTheme.black,
                      fillColor: MaterialStateProperty.all(OwnTheme.white),
                      value: isScan,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: OwnTheme.black),
                          borderRadius: BorderRadius.circular(5)),
                      onChanged: (bool? value) {
                        setState(() {
                          isScan = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // start Day field
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedOffDay,
                  decoration: AuthScreensFieldDecoration.fieldDecoration(
                    "Day Off",
                    null,
                    context: context,
                  ),
                  focusNode: startDayNameFocusNode,
                  onChanged: (value) {
                    setState(() {
                      selectedOffDay = value!;
                    });
                  },
                  items: weekdays.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Choose Off Day';
                    }
                    return null;
                  },
                ),
              ),

              // End day Field
              // Padding(
              //   padding: const EdgeInsets.all(paddingAll),
              //   child: DropdownButtonFormField(
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     value: selectedEndDay,
              //     decoration: AuthScreensFieldDecoration.fieldDecoration(
              //       "End Day",
              //       null,
              //       context: context,
              //     ),
              //     focusNode: endDayNameFocusNode,
              //     onChanged: (value) {
              //       setState(() {
              //         selectedEndDay = value!;
              //       });
              //     },
              //     items: weekdays.map((String item) {
              //       return DropdownMenuItem(
              //         enabled: true,
              //         value: item,
              //         child: Text(item),
              //       );
              //     }).toList(),
              //     validator: (value) {
              //       if (value == null) {
              //         return 'Choose End Day';
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // Start Hour picker
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    onTap: () async {
                      TimeOfDay? picked = await TimePicker.selectTime(context);
                      if (picked != null) {
                        var hour = picked.hour;
                        var minute = picked.minute;
                        setState(() {
                          startHour = picked;
                          startHourController.text = "$hour:$minute";
                        });
                      }
                    },
                    readOnly: true,
                    key: const ValueKey('startHour'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: startHourController,
                    focusNode: startHourFocusNode,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Choose Start Hour";
                      }
                      return null;
                    },
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Start Hour", null,
                        context: context,
                        suffix: Icons.hourglass_empty_rounded,
                        floatingLable: true),
                    onFieldSubmitted: (_) => endHourFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),

              // End Hour picker
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    onTap: () async {
                      TimeOfDay? picked = await TimePicker.selectTime(context);
                      if (picked != null) {
                        var hour = picked.hour;
                        var minute = picked.minute;
                        setState(() {
                          endHour = picked;
                          endHourController.text = "$hour:$minute";
                        });
                      }
                    },
                    readOnly: true,
                    key: const ValueKey('endDate'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: endHourController,
                    focusNode: endHourFocusNode,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Choose End Hour";
                      }
                      return null;
                    },
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "End Hour", null,
                        context: context,
                        suffix: Icons.hourglass_full_rounded,
                        floatingLable: true),
                    //onFieldSubmitted: (_) => endDateFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: DropdownButtonFormField(
                  value: slectedPlaceType,
                  decoration: AuthScreensFieldDecoration.fieldDecoration(
                    "Category",
                    null,
                    context: context,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                  style:
                      OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.black),
                  dropdownColor: OwnTheme.white,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: OwnTheme.primaryColor,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: typeFocusNode,
                  items: placesTypeslist.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      slectedPlaceType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Choose Category'; // Return an error message if no option is selected
                    }
                    return null; // Return null if the value is valid
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('ename'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: nameController,
                    focusNode: nameFocusNode,
                    onChanged: (fname) {
                      PreciseValidate.field(fname);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    cursorColor: OwnTheme.black,
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Place Name", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => urlFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('url'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: urlController,
                    focusNode: urlFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Website URL", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => aboutFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('about'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: aboutController,
                    focusNode: aboutFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "About", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => countryFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('country'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: countryController,
                    focusNode: countryFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Country", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => governmentFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('government'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: goventmentController,
                    focusNode: governmentFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Government/State", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => cityFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('city'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: cityController,
                    focusNode: cityFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "City", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => streetFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('street'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: streetController,
                    focusNode: streetFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Street", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => buildingFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('building'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: buildingController,
                    focusNode: buildingFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      //PreciseValidate.field(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    //validator: (fname) => PreciseValidate.field(fname ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Building Number", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => lowPriceFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('lowPrice'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: lowPriceController,
                    focusNode: lowPriceFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.isNumeric(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.isNumeric(fname)
                        ? null
                        : "Worng number",
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Ticket Low Price", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => highPriceFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                    key: const ValueKey('highPrice'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: highPriceController,
                    focusNode: highPriceFocusNode,
                    cursorColor: OwnTheme.black,
                    onChanged: (val) {
                      PreciseValidate.isNumeric(val);
                    },
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    validator: (fname) => PreciseValidate.isNumeric(fname)
                        ? null
                        : "Worng number",
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                        "Ticket High Price", null,
                        context: context, floatingLable: true),
                    onFieldSubmitted: (_) => currencyFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: TextFormField(
                  key: const ValueKey('currency'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: currencyController,
                  focusNode: currencyFocusNode,
                  cursorColor: OwnTheme.black,
                  onChanged: (val) {
                    PreciseValidate.field(val);
                  },
                  style:
                      OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.black),
                  validator: (fname) => fname == null
                      ? "Empty field"
                      : fname.isEmpty
                          ? "Empty field"
                          : null,
                  decoration: AuthScreensFieldDecoration.fieldDecoration(
                      "Currency", null,
                      context: context, floatingLable: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: Center(
                    child: CustomButton(
                  label: widget.place != null && widget.details != null
                      ? "Update"
                      : "Create",
                  onPressed: () async =>
                      widget.place != null && widget.details != null
                          ? await updateEvent(context)
                          : creatEvent(context),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void creatEvent(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    DateTime startDay = DateTime.now();
    DateTime endDay = DateTime.now();

    if (selectedOffDay != null) {
      startDay = _calculateNextWeekday(selectedOffDay!);
    }

    if (selectedEndDay != null) {
      endDay = _calculateNextWeekday(selectedEndDay!);
    }

    DateTime start = DateTime(startDay.year, startDay.month, startDay.day,
        startHour!.hour, startHour!.minute);
    DateTime end = DateTime(
        endDay.year, endDay.month, endDay.day, endHour!.hour, endHour!.minute);

    PlaceDetailsModel placeDetails = PlaceDetailsModel(
      about: aboutController.text,
      url: urlController.text,
      lowPrice: double.parse(lowPriceController.text),
      highPrice: double.parse(highPriceController.text),
      currency: currencyController.text,
    );

    PlaceModel newEvent = PlaceModel(
      name: nameController.text.toLowerCase(),
      country: countryController.text,
      governorate: goventmentController.text,
      city: cityController.text,
      streetName: streetController.text,
      buildingNumber: buildingController.text,
      startDay: startDay,
      price: double.parse(lowPriceController.text),
      startHour: start,
      endHour: end,
      isEventsAndActivities: isEventsAndActivities,
      isVenue: isVenue,
      isScan: isScan,
      type: slectedPlaceType,
      dayOffName: selectedOffDay,
    );

    final Map<String, dynamic> args = {
      'place': newEvent,
      'details': placeDetails,
    };

    Navigator.pushNamed(
      context,
      UploadPlaceImagesScreen.routeName,
      arguments: args,
    );
  }

  Future<void> updateEvent(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    DateTime startDay = DateTime.now();
    DateTime endDay = DateTime.now();

    if (selectedOffDay != null) {
      startDay = _calculateNextWeekday(selectedOffDay!);
    }

    if (selectedEndDay != null) {
      endDay = _calculateNextWeekday(selectedEndDay!);
    }

    DateTime start = DateTime(startDay.year, startDay.month, startDay.day,
        startHour!.hour, startHour!.minute);
    DateTime end = DateTime(
        endDay.year, endDay.month, endDay.day, endHour!.hour, endHour!.minute);

    PlaceDetailsModel placeDetails = widget.details!.copyWith(
      about: aboutController.text,
      url: urlController.text,
      lowPrice: double.parse(lowPriceController.text),
      highPrice: double.parse(highPriceController.text),
      currency: currencyController.text,
    );

    PlaceModel newEvent = widget.place!.copyWith(
      name: nameController.text.toLowerCase(),
      country: countryController.text,
      governorate: goventmentController.text,
      price: double.parse(lowPriceController.text),
      city: cityController.text,
      streetName: streetController.text,
      buildingNumber: buildingController.text,
      startDay: startDay,
      startHour: start,
      endHour: end,
      isEventsAndActivities: isEventsAndActivities,
      isVenue: isVenue,
      isScan: isScan,
      type: slectedPlaceType,
      startDayName: selectedOffDay,
    );

    bool res =
        await FirebaseRepo.updatePlacesInfoInFirestore(newEvent, placeDetails);
    if (res) {
      HomeBloc.get(context).add(SetHomeTabEvent(HomeTab.home));
      PlacesBloc.get(context).add(GetVenuesEvent([]));
      PlacesBloc.get(context).add(GetEventsAndActivitiesPlacesEvent([]));
      Navigation.emptyNavigator(HomeScreen.routeName, context, null);
    } else {
      FailureUiHandling.showToast(
        context: context,
        errorMsg: "Error in Update",
      );
    }

    print(newEvent.toString());
    print(placeDetails.toString());
  }

  DateTime _calculateNextWeekday(String weekday) {
    DateTime now = DateTime.now();
    int today = now.weekday;
    int targetDay = weekdays.indexOf(weekday) +
        1; // Adding 1 because DateTime considers Monday as 1

    int difference = targetDay - today;
    difference +=
        difference <= 0 ? 7 : 0; // Add 7 if the target day is before today

    return now.add(Duration(days: difference));
  }
}
