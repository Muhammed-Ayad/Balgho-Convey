class QuranException implements Exception {
  String message;
  QuranException([this.message = 'Something went wrong']) {
    message = 'Quran Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
