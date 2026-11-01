class NotificationDiagnosticsModel {
  final bool areNotificationsEnabled;
  final bool canScheduleExact;
  final String timezone;
  final int pendingCount;
  final List<String> pendingSummaries;

  const NotificationDiagnosticsModel({
    required this.areNotificationsEnabled,
    required this.canScheduleExact,
    required this.timezone,
    required this.pendingCount,
    this.pendingSummaries = const [],
  });

  NotificationDiagnosticsModel copyWith({
    bool? areNotificationsEnabled,
    bool? canScheduleExact,
    String? timezone,
    int? pendingCount,
    List<String>? pendingSummaries,
  }) {
    return NotificationDiagnosticsModel(
      areNotificationsEnabled:
          areNotificationsEnabled ?? this.areNotificationsEnabled,
      canScheduleExact: canScheduleExact ?? this.canScheduleExact,
      timezone: timezone ?? this.timezone,
      pendingCount: pendingCount ?? this.pendingCount,
      pendingSummaries: pendingSummaries ?? this.pendingSummaries,
    );
  }
}
