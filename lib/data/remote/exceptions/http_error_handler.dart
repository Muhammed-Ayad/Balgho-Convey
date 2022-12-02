
import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final String errorMessage =
      'Request failed\nStatus Code: $statusCode\nReason: $reasonPhrase';

  return errorMessage;
}