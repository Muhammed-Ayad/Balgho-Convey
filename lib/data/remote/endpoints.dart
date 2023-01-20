mixin AppEndpoints {
  static const _baseUrl = 'assets/json';

  static const quranApi = '$_baseUrl/quran.json';
  static const radiosApi = '$_baseUrl/radios.json';
  static const nawawiApi = '$_baseUrl/nawawi.json';
  static String azanUrl =
      'https://api.aladhan.com/v1/timingsByCity?city=cairo&country=Egypt';
  static const mailTo = "mailto:mohamedayaddev@gmail.com";

  static const linkPlayGoogle =
      "https://play.google.com/store/apps/details?id=com.convey.ayah.mohamed.ayad";
}
