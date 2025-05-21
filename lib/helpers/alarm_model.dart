class Alarm {
  final DateTime dateTime;
  final bool enabled;

  Alarm({required this.dateTime, this.enabled = true});

  Alarm copyWith({DateTime? dateTime, bool? enabled}) {
    return Alarm(
      dateTime: dateTime ?? this.dateTime,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'enabled': enabled,
      };

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        dateTime: DateTime.parse(json['dateTime']),
        enabled: json['enabled'] ?? true,
      );
}