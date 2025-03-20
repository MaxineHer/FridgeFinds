import 'package:flutter/material.dart';
import 'home_page.dart';
import 'userprofile_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  // Sample notifications
  List<NotificationItem> notifications = [
    NotificationItem(
      message:
      'Your bread will expire in 2 days! Wanna take a quick look at it?',
      date: '22 June 2024',
      status: NotificationStatus.warning,
    ),
    NotificationItem(
      message: 'Thank you for updating your fridge inventory!',
      date: '15 July 2024',
      status: NotificationStatus.success,
    ),
    NotificationItem(
      message: 'Your milk has expired!',
      date: '25 May 2024',
      status: NotificationStatus.error,
    ),
    NotificationItem(
      message:
      'Your smart shopping is created! You\'re all set for your next grocery run.',
      date: '10 April 2024',
      status: NotificationStatus.success,
    ),
  ];

  // Method to remove a notification
  void _removeNotification(NotificationItem notification) {
    setState(() {
      notifications.remove(notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar without a background color
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'PlayfairDisplay'),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: ListView(
          children: notifications.map((notification) {
            return NotificationTile(
              notification: notification,
              onDismiss: () {
                _removeNotification(notification);
              },
            );
          }).toList(),
        ),
      ),
      // Added BottomNavigation bar to this page
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class NotificationItem {
  final String message;
  final String date;
  final NotificationStatus status;

  NotificationItem({
    required this.message,
    required this.date,
    required this.status,
  });
}

enum NotificationStatus { success, error, warning }

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Icon statusIcon;

    // Define colors and icons based on the notification status
    switch (notification.status) {
      case NotificationStatus.success:
        statusColor = Colors.green.shade200;
        statusIcon =
        const Icon(Icons.check_circle, color: Colors.green);
        break;
      case NotificationStatus.error:
        statusColor = Colors.red.shade200;
        statusIcon =
        const Icon(Icons.error, color: Colors.red);
        break;
      case NotificationStatus.warning:
        statusColor = Colors.orange.shade200;
        statusIcon =
        const Icon(Icons.warning, color: Colors.orange);
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: statusColor.withValues(), // Background based on status
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0),
        leading: statusIcon,
        title: Text(
          notification.message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            fontFamily: 'Sen',
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          notification.date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Sen',
            color: Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: onDismiss,
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF6E86D0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home icon navigates back to HomeScreen from home_page.dat
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const HomeScreen(userName: 'User'),
                ),
              );
            },
            icon: const Icon(Icons.home,
                color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              // Navigate to grocery lists
            },
            icon: const Icon(Icons.list,
                color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const UserPage(),
                ),
              );
            },
            icon: const Icon(Icons.person,
                color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}