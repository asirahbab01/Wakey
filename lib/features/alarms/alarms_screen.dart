import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../helpers/alarm_model.dart' as alarm_model;
import 'alarm_storage.dart';
import 'package:wakey/common_widgets/alarm_tile.dart';

class AlarmsScreen extends StatefulWidget {
  final String location;
  const AlarmsScreen({super.key, required this.location});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  List<alarm_model.Alarm> _alarms = [];
  late FlutterLocalNotificationsPlugin _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = FlutterLocalNotificationsPlugin();
    _initNotifications();
    _loadAlarms();
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _notifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    tz.initializeTimeZones(); // required for zonedSchedule
  }

  Future<void> _loadAlarms() async {
    final alarms = await AlarmStorage.loadAlarms();
    setState(() => _alarms = alarms); // No cast needed
  }

  Future<void> _saveAlarms() async {
    await AlarmStorage.saveAlarms(_alarms); // No cast needed
  }

  Future<void> _addAlarm() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final alarmDateTime = DateTime(
      picked.year,
      picked.month,
      picked.day,
      time.hour,
      time.minute,
    );
    final alarm = alarm_model.Alarm(dateTime: alarmDateTime);
    setState(() {
      _alarms.add(alarm);
    });
    await _saveAlarms();
    _scheduleNotification(alarm);
  }

  Future<void> _scheduleNotification(alarm) async {
    final scheduledDate = tz.TZDateTime.from(alarm.dateTime, tz.local);
    const android = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(android: android, iOS: ios);

    await _notifications.zonedSchedule(
      alarm.dateTime.millisecondsSinceEpoch ~/ 1000, // Unique ID
      'Alarm',
      'It\'s time for your alarm!',
      scheduledDate,
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  void _toggleAlarm(int index, bool value) async {
    setState(() {
      _alarms[index] = _alarms[index].copyWith(enabled: value);
    });
    await _saveAlarms();
    if (value) {
      _scheduleNotification(_alarms[index]);
    } else {
      await _notifications
          .cancel(_alarms[index].dateTime.millisecondsSinceEpoch ~/ 1000);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    return Scaffold(
      backgroundColor: const Color(0xFF232428),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232428),
        elevation: 0,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Selected Location",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _addAlarm,
                child: const Text("Add Alarm"),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Alarms",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  final alarm = _alarms[index];
                  return AlarmTile(
                      alarm: alarm,
                      onToggle: (value) => _toggleAlarm(index, value),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
