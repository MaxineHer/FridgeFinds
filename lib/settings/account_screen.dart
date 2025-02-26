import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account", style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 20, fontWeight: FontWeight.bold)),
        content: const Text(
          "Are you sure you want to delete your account? This action is irreversible.",
          style: TextStyle(fontFamily: 'Sen', fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(fontFamily: 'Sen', fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement account deletion logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account deleted successfully")),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red, fontFamily: 'Sen', fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Settings",
          style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Two-Step Verification",
              icon: Icon(Icons.lock),
            ),
            Tab(
              text: "Delete Account",
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TwoStepVerificationScreen(),
          Center(
            child: ElevatedButton(
              onPressed: _confirmDeleteAccount,
              child: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoStepVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose verification method:",
            style: TextStyle(fontFamily: 'Sen', fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text(
              "Verify via Gmail",
              style: TextStyle(fontFamily: 'Sen', fontSize: 16),
            ),
            onTap: () {
              // TODO: Implement Gmail verification logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gmail verification initiated")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text(
              "Verify via Phone Number",
              style: TextStyle(fontFamily: 'Sen', fontSize: 16),
            ),
            onTap: () {
              // TODO: Implement phone number verification logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Phone verification initiated")),
              );
            },
          ),
        ],
      ),
    );
  }
}
