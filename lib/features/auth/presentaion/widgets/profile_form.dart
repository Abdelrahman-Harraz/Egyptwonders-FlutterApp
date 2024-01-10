import 'package:country_picker/country_picker.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/core/utililty/validations/percise_validation.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/field_decoration.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../../home/presentaition/screens/home_screen.dart';

class ProfileForm extends StatefulWidget {
  UserModel userModel;
  ProfileForm({super.key, required this.userModel});
  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final emailFocusNode = FocusNode();
  final fnameFocusNode = FocusNode();
  final nickNameFocusNode = FocusNode();
  final nationalityFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final birthdayFocusNode = FocusNode();
  final genderFocusNode = FocusNode();

  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  PhoneNumber initPhone = PhoneNumber(isoCode: 'EG');
  PhoneNumber selectedPhone = PhoneNumber(isoCode: 'EG');
  DateTime _selectedDate = DateTime.now();
  DateFormat format = new DateFormat('MM/dd/yyyy');
  int? genderVal;

  @override
  void initState() {
    super.initState();
    _setPhone(); // Initialize phone number based on user data
    setState(() {
      fnameController.text = widget.userModel.fullName ?? "";
      nickNameController.text = widget.userModel.nickName ?? "";
      nationalityController.text = widget.userModel.nationality ?? "";
      emailController.text = widget.userModel.email ?? "";
      birthdayController.text = widget.userModel.birthDate != null
          ? DateFormat('MM/dd/yyyy').format(widget.userModel.birthDate!)
          : "";
      genderVal = widget.userModel.gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fullname Field
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: TextFormField(
                key: const ValueKey('fname'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: fnameController,
                focusNode: fnameFocusNode,
                onChanged: (fname) {
                  PreciseValidate.name(fname);
                },
                style: OwnTheme.bodyTextStyle()
                    .copyWith(color: OwnTheme.darkTextColor),
                cursorColor: Colors.black,
                validator: (fname) => PreciseValidate.name(fname ?? ""),
                decoration: AuthScreensFieldDecoration.fieldDecoration(
                  "Full Name",
                  null,
                  context: context,
                ),
                onFieldSubmitted: (_) => nickNameFocusNode.requestFocus(),
                textInputAction: TextInputAction.next),
          ),
          //nickname
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: TextFormField(
                key: const ValueKey('nickname'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nickNameController,
                focusNode: nickNameFocusNode,
                cursorColor: OwnTheme.white,
                onChanged: (nName) {
                  PreciseValidate.nickName(nName);
                },
                style: OwnTheme.bodyTextStyle()
                    .copyWith(color: OwnTheme.darkTextColor),
                validator: (fname) => PreciseValidate.name(fname ?? ""),
                decoration: AuthScreensFieldDecoration.fieldDecoration(
                  "Nickname",
                  null,
                  context: context,
                ),
                onFieldSubmitted: (_) => nationalityFocusNode.requestFocus(),
                textInputAction: TextInputAction.next),
          ),

          // Nationality
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: false,
                onSelect: (Country country) {
                  setState(() {
                    nationalityController.text = country.name;
                  });
                },
              );
            },
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: SizedBox(
                  width: 95.w,
                  child: TextFormField(
                    key: const ValueKey('nationality'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: nationalityController,
                    focusNode: nationalityFocusNode,
                    onChanged: (val) {
                      PreciseValidate.field(val);
                    },
                    style:
                        OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
                    validator: (nationality) =>
                        PreciseValidate.nationality(nationality ?? ""),
                    decoration: AuthScreensFieldDecoration.fieldDecoration(
                      "Nationality",
                      null,
                      context: context,
                    ),
                    onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
                  ),
                ),
              ),
            ),
          ),

          // Email Field
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: TextFormField(
                focusNode: emailFocusNode,
                controller: emailController,
                readOnly: true,
                decoration: AuthScreensFieldDecoration.fieldDecoration(
                    "Email", null, context: context, suffix: Icons.email),
                style: OwnTheme.bodyTextStyle()
                    .copyWith(color: OwnTheme.darkTextColor),
                textInputAction: TextInputAction.next),
          ),

          // phone number Field
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: InternationalPhoneNumberInput(
              errorMessage: 'Wrong phone number',
              selectorButtonOnErrorPadding: 50,
              focusNode: phoneFocusNode,
              textAlign: TextAlign.left,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  selectedPhone = number;
                });
              },
              onFieldSubmitted: (value) => birthdayFocusNode.requestFocus(),
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true,
                  leadingPadding: 20,
                  trailingSpace: false,
                  useEmoji: true),
              inputDecoration: AuthScreensFieldDecoration.fieldDecoration(
                  "100 000 0000",
                  context: context,
                  null,
                  passwordVisible: null),
              keyboardAction: TextInputAction.next,
              spaceBetweenSelectorAndTextField: 0,
              textStyle: OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
              ignoreBlank: false,
              selectorTextStyle:
                  OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
              initialValue: initPhone,
              formatInput: true,
              cursorColor: Colors.black,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
            ),
          ),

          // Birth date
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: TextFormField(
                onTap: () async {
                  await _selectDate(context);
                },
                readOnly: true,
                key: const ValueKey('age'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: birthdayController,
                focusNode: birthdayFocusNode,
                style: OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Choose your birth date";
                  }
                  return null;
                },
                decoration: AuthScreensFieldDecoration.fieldDecoration(
                    "Date of Birth", null,
                    context: context, suffix: Icons.calendar_month),
                onFieldSubmitted: (_) => genderFocusNode.requestFocus(),
                textInputAction: TextInputAction.next),
          ),

          // Gender
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: DropdownButtonFormField(
              value: genderVal,
              decoration: AuthScreensFieldDecoration.fieldDecoration(
                "Gender",
                null,
                context: context,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              style: OwnTheme.bodyTextStyle(),
              dropdownColor: OwnTheme.white,
              icon: Icon(
                Icons.arrow_drop_down,
                color: OwnTheme.primaryColor,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              focusNode: genderFocusNode,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    'Male',
                    style:
                        OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    'Female',
                    style:
                        OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  genderVal = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Choose your gender'; // Return an error message if no option is selected
                }
                return null; // Return null if the value is valid
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingAll),
            child: Center(
                child: CustomButton(
              label: "Continue",
              onPressed: () => updateProfile(context),
            )),
          ),
        ],
      ),
    );
  }

  // Function to update the user profile
  void updateProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    UserModel newUser;
    try {
      newUser = UserModel(
          fullName: fnameController.text,
          nickName: nickNameController.text,
          nationality: nationalityController.text,
          email: emailController.text,
          phone: selectedPhone.phoneNumber,
          birthDate: format.parse(birthdayController.text),
          gender: genderVal);
    } catch (e) {
      FailureUiHandling.showToast(
        context: context,
        errorMsg: e.toString(),
      );
      return;
    }
    AuthBloc.get(context).add(UpdateProfileEvent(newUser));
    PlacesBloc.get(context).add(GetVenuesEvent([]));
    PlacesBloc.get(context).add(GetEventsAndActivitiesPlacesEvent([]));
    Navigation.emptyNavigator(HomeScreen.routeName, context, null);
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        birthdayController.text = DateFormat('MM/dd/yyyy').format(picked);
        _selectedDate = picked;
      });
    }
  }

  // Function to set the initial phone number
  void _setPhone() async {
    try {
      var tempPhone = null;
      if (widget.userModel.phone != null) {
        if (widget.userModel.phone!.isNotEmpty) {
          tempPhone = await PhoneNumber.getRegionInfoFromPhoneNumber(
              widget.userModel.phone!);
        }
      }
      setState(() {
        initPhone = tempPhone ?? initPhone;
        selectedPhone = initPhone;
      });
    } catch (e) {
      print("phoneee exxxx");
      print(e);
    }
  }
}
