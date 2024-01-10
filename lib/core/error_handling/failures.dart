// Abstract class representing a generic failure entity with a message
abstract class FailureEntity {
  String message;

  // Constructor with an optional default message
  FailureEntity({
    this.message = "",
  });
}

// Concrete class representing a server-related failure
class ServerFailure extends FailureEntity {}

// Concrete class representing a failure related to data parsing
class DataParsingFailure extends FailureEntity {}

// Concrete class representing a failure due to no internet connection
class NoConnectionFailure extends FailureEntity {}

// Concrete class representing a failure due to invalid email or password
class InvalidMailAndPassword extends FailureEntity {}

// Concrete class representing a failure due to invalid data with a specific message
class InvalidDataFailure extends FailureEntity {
  InvalidDataFailure({
    required String message,
  }) : super(message: message);
}
