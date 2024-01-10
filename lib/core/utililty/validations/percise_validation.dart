import 'package:email_validator/email_validator.dart';

import 'utility.dart';

// Class containing static methods for precise form field validation
class PreciseValidate {
  // Validate if a value is required and not empty
  static String? required(String value,
      {bool isRequired = true, String message = "This field cannot be empty"}) {
    if (isRequired && Utility.isNullOrEmpty(value)) {
      return message;
    } else {
      return null;
    }
  }

  // Validate a name field
  static String? name(String name) {
    if (name.isEmpty) {
      return "Name can't be empty";
    }
    if (name.length < 2) {
      return "Short name";
    }
    return null;
  }

  // Validate a nickname field
  static String? nickName(String nickName) {
    if (nickName.isEmpty) {
      return "Nickname can't be empty";
    }

    return null;
  }

  // Validate a nationality field
  static String? nationality(String nationality) {
    if (nationality.isEmpty) {
      return "Nationality can't be empty";
    }

    return null;
  }

  // Validate a general field
  static String? field(String val) {
    if (val.isEmpty) {
      return "field can't be empty";
    }
    if (val.length < 2) {
      return "Short value";
    }
    return null;
  }

  // Validate a login password
  static String? loginPassword(String value,
      {bool isRequired = true, String message = "Password"}) {
    if (isRequired && Utility.isNullOrEmpty(value)) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return 'Enter a password with length at least 6';
    } else {
      return null;
    }
  }

  // Validate a complex password
  static String? complexPassword(String password,
      {bool isRequired = true, String message = "Password can't be empty"}) {
    if (isRequired && Utility.isNullOrEmpty(password)) {
      return message;
    }
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      return "passwordLowerCaseErr";
    }

    if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(password)) {
      return "passwordUpperCaseErr";
    }

    if (!RegExp('^.{5,15}').hasMatch(password)) {
      return "passwordGreater4Err";
    } else {
      return null;
    }
  }

  // Validate an email field
  static String? email(
    String value, {
    bool isRequired = true,
    String message = "Email has incorrect format",
    String msgIfRequired = 'Email cannot be empty',
  }) {
    if (EmailValidator.validate(value)) {
      return null;
    } else if (isRequired && Utility.isNullOrEmpty(value)) {
      return msgIfRequired;
    } else {
      return "Wrong Email Format";
    }
  }

  // Check if a string is numeric
  static bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) == null ? false : true;
  }

  // Validate a birth date field
  static String? birthDate(
    DateTime value, {
    bool isRequired = true,
    String message = "Please select your birth date",
  }) {
    if (value.year == DateTime.now().year) {
      return "";
    }
    return null;
  }

  // Validate a pin code field
  static String? pincode(String code, int length) {
    if (Utility.isNullOrEmpty(code)) {
      return "Verification code can't be empty";
    } else if (code.length < length) {
      return "Please enter the whole verification code";
    } else if (!isNumeric(code)) {
      return "Please enter the valid verification code";
    } else {
      return null;
    }
  }

  // Check if a phone number is a valid Egyptian phone number
  static bool isEgyptianPhoneNumber(String phone) {
    return isNumeric(phone) &&
        phone.length == 11 &&
        phone.startsWith(RegExp(r'(011|012|010)'));
  }
}
