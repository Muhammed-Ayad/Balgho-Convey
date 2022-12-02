class CustomException implements Exception {
  final String key;
  final String? message;

  CustomException({this.key = "errors_something_went_wrong", this.message});
  @override
  String toString() => '$key\n${message ?? ''}';
}

class NoConnectionException extends CustomException {
  NoConnectionException({String? message})
      : super(key: "errors_no_internet_connection", message: message);
}

class FetchDataException extends CustomException {
  FetchDataException({String? message})
      : super(key: "errors_fetch_data", message: message);
}

class SerializationException extends CustomException {
  SerializationException({String? message})
      : super(key: "errors_serialization", message: message);
}

class BadRequestException extends CustomException {
  BadRequestException({String? message})
      : super(key: "errors_bad_request", message: message);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException({String? message})
      : super(key: "errors_unauthorized", message: message);
}

class ServerException extends CustomException {
  ServerException({String? message})
      : super(key: "errors_unauthorized", message: message);
}

class InvalidInputException extends CustomException {
  InvalidInputException({String? message})
      : super(key: "errors_invalid_inputs", message: message);
}
