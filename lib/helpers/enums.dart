enum OS {
  android,
  ios,
  web,
}

enum AzkarType {
  morning,
  evening;

  static AzkarType fromName(String name) {
    if (name == AzkarType.morning.name) {
      return AzkarType.morning;
    } else if (name == AzkarType.evening.name) {
      return AzkarType.evening;
    } else {
      // Default Value
      return AzkarType.morning;
    }
  }
}
