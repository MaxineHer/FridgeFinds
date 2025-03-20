import 'package:flutter/material.dart';
import 'package:fridge_finds/manasvi-branch/home_page.dart';
import 'package:fridge_finds/vaish-branch/grocery_list.dart';
import 'package:fridge_finds/manasvi-branch/userprofile_page.dart';

void main() {
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserPage(),
              ),
            );
          },
        ),

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
      'question': 'What is FridgeFinds?',
      'answer': 'FridgeFinds is a smart fridge app that transforms kitchen management by connecting with smart fridges to track groceries in real-time.',
      'isExpanded': false,
    },
    {
      'question': 'How do I connect my fridge to the app?',
      'answer': 'Simply tap on "Add Fridge" on the Connections screen, then scan your fridge’s QR code. The app will automatically add your fridge to your account once the scan is successful.',
      'isExpanded': false,
    },
    {
      'question': 'Do I need an account to use FridgeFinds?',
      'answer': 'Yes, you need to sign in using Google authentication to link a fridge and access features.',
      'isExpanded': false,
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, your data is securely stored in Firebase, adhering to industry-standard encryption and security practices.',
      'isExpanded': false,
    },
    {
      'question': 'I’m having trouble connecting my fridge to the app. What should I do?',
      'answer': 'Ensure your smart fridge is powered on and connected to the internet. Restart the app, and retry the connectivity setup.',
      'isExpanded': false,
    },
    {
      'question': 'How do I remove a fridge from my account?',
      'answer': 'In the Fridge Details screen, tap on the "Remove Fridge" button. You’ll be prompted with a confirmation dialog, if you confirm, the fridge will be deleted from your account.',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const HomeScreen(userName: 'User'), // Home screen page
                ),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroceryListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.list, color: Colors.white, size: 32),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPage(),
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}