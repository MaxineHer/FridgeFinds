import 'package:flutter/material.dart';
import 'adduser.dart';
import 'fridgecon1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQ Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
          ),
        ),
      ),
      home: const FAQScreen(),
    );
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),

        actions: [
          // 1) Navigate to AddUserScreen
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserScreen()),
              );
            },
          ),
          // 2) Navigate to FridgeConnectivityScreen
          IconButton(
            icon: const Icon(Icons.devices),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FridgeConnectivityScreen()),
              );
            },
          ),
        ],

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Frequently Asked',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Questions',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Expanded(child: FAQList()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class FAQList extends StatefulWidget {
  const FAQList({super.key});

  @override
  _FAQListState createState() => _FAQListState();
}

class _FAQListState extends State<FAQList> {
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'Can I share grocery lists with others?',
      'answer': 'Yes! You can invite friends or family to share your grocery lists.',
      'isExpanded': false,
    },
    {
      'question': 'The app isn’t recognizing some items in my fridge. What can I do?',
      'answer': 'Try rescanning the items or manually adding them.',
      'isExpanded': false,
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, your data is securely stored in Firebase and Google Cloud Platform, adhering to industry-standard encryption and security practices.',
      'isExpanded': false,
    },
    {
      'question': 'I’m having trouble connecting my fridge to the app. What should I do?',
      'answer': 'Ensure your smart fridge is powered on and connected to the internet. Restart the app, and retry the connectivity setup.',
      'isExpanded': false,
    },
  ];

  void _toggleExpansion(int index) {
    setState(() {
      _faqItems[index]['isExpanded'] = !_faqItems[index]['isExpanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final faq = _faqItems[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  faq['question'],
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    faq['isExpanded'] ? Icons.remove : Icons.add,
                    color: Colors.blue,
                  ),
                  onPressed: () => _toggleExpansion(index),
                ),
              ),
              if (faq['isExpanded'])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    faq['answer'],
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF6E86D0),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      selectedFontSize: 0,
      unselectedFontSize: 0,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt, size: 30), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: ""),
      ],
    );
  }
}

