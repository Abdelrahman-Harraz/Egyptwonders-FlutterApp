// Importing the Equatable package for easy equality checks
import 'package:equatable/equatable.dart';
// Importing the custom failures file
import 'failures.dart';

// A class representing an error object that extends Equatable for equality comparison
class ErrorObject extends Equatable {
  // Constructor for ErrorObject taking a title and message as required parameters
  const ErrorObject({
    required this.title,
    required this.message,
  });

  // Title of the error
  final String title;
  // Message describing the error
  final String message;

  // Override the Equatable props getter to define the properties used for equality comparison
  @override
  List<Object?> get props => [title, message];

  // A static method to map a FailureEntity to an ErrorObject
  static ErrorObject mapFailureToErrorObject({required FailureEntity failure}) {
    // Check the type of failure and create an ErrorObject accordingly
    if (failure is ServerFailure) {
      return const ErrorObject(
          title: 'Error Code: INTERNAL_SERVER_FAILURE',
          message:
              'It seems that the server is not reachable at the moment, try '
              'again later');
    } else if (failure is DataParsingFailure) {
      return const ErrorObject(
          title: 'Error Code: JSON_PARSING_FAILURE',
          message: 'It seems that the app needs to be updated');
    } else if (failure is NoConnectionFailure) {
      return const ErrorObject(
          title: 'Error Code: NO_CONNECTIVITY',
          message: 'It seems that your device is not connected to the network, '
              'please check your internet connectivity or try again later.');
    } else if (failure is InvalidMailAndPassword) {
      return const ErrorObject(
          title: 'Error Code: Wrong_Mail_Or_Password',
          message: 'Wrong E-mail Or Password');
    } else if (failure is InvalidDataFailure) {
      // If the failure is of type InvalidDataFailure, construct an ErrorObject using failure's message
      return ErrorObject(
          title: 'Error Code:INVALID_DATA', message: failure.message);
    } else {
      // Default case if the failure type is not recognized
      return const ErrorObject(title: 'Default error', message: '');
    }
  }
}
