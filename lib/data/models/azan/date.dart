class Date {
  final int timestamp;
  final String gregorian;
  final String hijri;
  Date({
    required this.timestamp,
    required this.gregorian,
    required this.hijri,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'gregorian': gregorian,
      'hijri': hijri,
    };
  }

  factory Date.fromJson(Map<String, dynamic> map) {
    return Date(
      timestamp: map['timestamp']?.toInt() ?? 0,
      gregorian: map['gregorian'] ?? '',
      hijri: map['hijri'] ?? '',
    );
  }
}
