mixin AppEndpoints {
  static const _baseUrl = 'assets/json';

  static const quranApi = '$_baseUrl/quran.json';
  static const radiosApi = '$_baseUrl/radios.json';
  static const nawawiApi = '$_baseUrl/nawawi.json';
  static String url =
      'https://api.aladhan.com/v1/calendarByCity?city=London&country=cairo%20Kingdom&method=2&month=12&year=2022';
  static const mailTo = "mailto:mohamedayaddev@gmail.com";

  static const linkPlayGoogle =
      "https://play.google.com/store/apps/details?id=com.convey.ayah.mohamed.ayad";
}
