import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/alarm_model.dart';

class AlarmStorage {
  static const _key = 'alarms';

  static Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final List list = jsonDecode(data);
    return list.map((e) => Alarm.fromJson(e)).toList();
  }

  static Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(alarms.map((e) => e.toJson()).toList());
    await prefs.setString(_key, data);
  }
}