class CustomException implements Exception {
  final String key;
  final String? message;

  CustomException({this.key = "errors_something_went_wrong", this.message});
  @override
  String toString() => '$key\n${message ?? ''}';
}

class NoConnectionException extends CustomException {
  NoConnectionException({super.message})
      : super(key: "errors_no_internet_connection");
}

class FetchDataException extends CustomException {
  FetchDataException({super.message}) : super(key: "errors_fetch_data");
}

class SerializationException extends CustomException {
  SerializationException({super.message}) : super(key: "errors_serialization");
}

class BadRequestException extends CustomException {
  BadRequestException({super.message}) : super(key: "errors_bad_request");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException({super.message}) : super(key: "errors_unauthorized");
}

class ServerException extends CustomException {
  ServerException({super.message}) : super(key: "errors_unauthorized");
}

class InvalidInputException extends CustomException {
  InvalidInputException({super.message}) : super(key: "errors_invalid_inputs");
}
