import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool notificationsEnabled = true;
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 0);
  Map<String, bool> notificationTypes = {
    'Promotions': true,
    'Reminders': true,
    'Updates': true,
  };

  void _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification Settings",
          style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Enable Notifications", style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.normal)),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            if (notificationsEnabled) ...[
              const SizedBox(height: 10),
              ListTile(
                title: Text("Notification Time: ${selectedTime.format(context)}", style: TextStyle(fontFamily: 'Sen', fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.timer),
                onTap: () => _pickTime(context),
              ),
              const SizedBox(height: 10),
              const Text("Select Notifications to Receive:", style: TextStyle(fontFamily:'Sen', fontWeight: FontWeight.bold)),
              Column(
                children: notificationTypes.keys.map((type) {
                  return CheckboxListTile(
                    title: Text(type),
                    value: notificationTypes[type],
                    onChanged: (value) {
                      setState(() {
                        notificationTypes[type] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
