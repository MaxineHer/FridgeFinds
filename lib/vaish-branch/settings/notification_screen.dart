/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool notificationsEnabled = true;
  bool expiringItemsEnabled = true;
  bool shoppingListEnabled = true;
  TimeOfDay selectedTime = const TimeOfDay(hour: 18, minute: 0);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _loadSettings();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleDailyNotification() async {
    if (!notificationsEnabled) return;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Notification',
      'Check your fridge for expiring items and new shopping lists!',
      _nextInstanceOfSelectedTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notifications',
          'Daily Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfSelectedTime() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        selectedTime.hour, selectedTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _loadSettings() async {
    var doc = await FirebaseFirestore.instance.collection('settings').doc('notifications').get();
    if (doc.exists) {
      setState(() {
        notificationsEnabled = doc['notificationsEnabled'] ?? true;
        expiringItemsEnabled = doc['expiringItemsEnabled'] ?? true;
        shoppingListEnabled = doc['shoppingListEnabled'] ?? true;
        selectedTime = TimeOfDay(
          hour: doc['notificationHour'] ?? 18,
          minute: doc['notificationMinute'] ?? 0,
        );
      });
    }
  }

  Future<void> _saveSettings() async {
    await FirebaseFirestore.instance.collection('settings').doc('notifications').set({
      'notificationsEnabled': notificationsEnabled,
      'expiringItemsEnabled': expiringItemsEnabled,
      'shoppingListEnabled': shoppingListEnabled,
      'notificationHour': selectedTime.hour,
      'notificationMinute': selectedTime.minute,
    });
    _scheduleDailyNotification();
  }

  void _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
      _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            if (notificationsEnabled) ...[
              ListTile(
                title: Text("Notification Time: ${selectedTime.format(context)}"),
                trailing: const Icon(Icons.timer),
                onTap: () => _pickTime(context),
              ),
              CheckboxListTile(
                title: const Text("Expiring Items Notifications"),
                value: expiringItemsEnabled,
                onChanged: (value) {
                  setState(() {
                    expiringItemsEnabled = value ?? false;
                  });
                  _saveSettings();
                },
              ),
              CheckboxListTile(
                title: const Text("Shopping List Notifications"),
                value: shoppingListEnabled,
                onChanged: (value) {
                  setState(() {
                    shoppingListEnabled = value ?? false;
                  });
                  _saveSettings();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
*/