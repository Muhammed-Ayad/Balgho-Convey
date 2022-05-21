class Location {
  final double latitude;
  final double longitude;
  final double elevation;
  final String city;
  final String country;
  final String countryCode;
  final String timezone;
  final double localOffset;
  Location({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.timezone,
    required this.localOffset,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'city': city,
      'country': country,
      'country_code': countryCode,
      'timezone': timezone,
      'local_offset': localOffset,
    };
  }

  factory Location.fromJson(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      elevation: map['elevation']?.toDouble() ?? 0.0,
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      countryCode: map['country_code'] ?? '',
      timezone: map['timezone'] ?? '',
      localOffset: map['local_offset']?.toDouble() ?? 0.0,
    );
  }
}
