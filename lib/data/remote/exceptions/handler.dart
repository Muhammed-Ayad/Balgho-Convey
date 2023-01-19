import 'package:dio/dio.dart';
import 'package:great_quran/data/remote/exceptions/exceptions.dart';

extension DioResponseHandler on Response {
  dynamic handle() {
    switch (statusCode) {
      case 200:
        try {
          return data;
        } catch (e) {
          throw SerializationException(message: e.toString());
        }
      case 400:
        throw BadRequestException(message: data);
      case 401:
      case 403:
        throw UnauthorizedException(message: data);
      case 500:
        throw ServerException(message: data);
      default:
        throw FetchDataException();
    }
  }
}
