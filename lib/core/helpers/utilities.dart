import 'package:great_quran/core/network/endpoints.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

mixin Utilities {
  static String dateTimeNow() =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<void> sendMessage() async {
    final Uri url = Uri.parse(AppEndpoints.mailTo);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Error $url";
    }
  }
}
