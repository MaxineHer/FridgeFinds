import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditProfilePage(),
  ));
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController(text: 'Jane Doe');
  final TextEditingController _emailController = TextEditingController(text: 'janedoe@gmail.com');
  final TextEditingController _phoneController = TextEditingController(text: '050-1234567');

  // For picking an image
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  // Function to pick a new profile image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // Using ImageSource

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Function to save the updated data
  void _saveData() {
    if (_formKey.currentState?.validate() ?? false) {
      // Add logic to save the data (e.g., store in database or API)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );
    } else {
      // Show a message to alert user if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields before saving.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with Edit Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 80, // Increased size
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: _profileImage == null
                            ? null
                            : FileImage(_profileImage!),
                        child: _profileImage == null
                            ? Icon(Icons.person, color: Colors.white, size: 80)
                            : null,
                      ),
                      // Edit Icon
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Full Name
                _buildTextFormField(_nameController, 'Full Name'),
                SizedBox(height: 30), // Increased space

                // Email
                _buildTextFormField(_emailController, 'Email'),
                SizedBox(height: 30), // Increased space

                // Phone Number
                _buildTextFormField(_phoneController, 'Phone Number'),
                SizedBox(height: 30), // Increased space

                // Save Button (disabled if fields are invalid)
                Center(
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      textStyle: TextStyle(fontSize: 16, fontFamily: 'Sen'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextFormField to avoid repetition and keep the UI clean
  Widget _buildTextFormField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Sen',
            fontSize: 20,
            fontWeight: FontWeight.bold, // Bold heading
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        style: TextStyle(fontFamily: 'Sen', fontSize: 21),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }
}