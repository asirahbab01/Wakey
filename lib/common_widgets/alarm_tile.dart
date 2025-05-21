import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/alarm_model.dart'; // Use the shared model

class AlarmTile extends StatelessWidget {
  final Alarm alarm;
  final ValueChanged<bool> onToggle;

  const AlarmTile({super.key, required this.alarm, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('h:mm a').format(alarm.dateTime);
    final date = DateFormat('EEE dd MMM yyyy').format(alarm.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF35363A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.08,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: alarm.enabled,
            activeColor: Colors.purple,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
