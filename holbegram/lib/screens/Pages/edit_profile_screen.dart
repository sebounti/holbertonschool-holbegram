import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:holbegram/screens/login_screen.dart';

// Main class for the profile edit screen
class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

// State associated with the EditProfileScreen class
class EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with user data
    _usernameController.text = widget.userData['username'];
    _bioController.text = widget.userData['bio'];
  }

  @override
  void dispose() {
    // Release the resources of the controllers
    _usernameController.dispose();
    _bioController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to update the user profile
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Update the password if a new password is provided
      if (_newPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New password and confirmation do not match')),
          );
          return;
        }

        String email = user!.email!;
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: _currentPasswordController.text);
        await user.updatePassword(_newPasswordController.text);
      }

      String photoUrl = widget.userData['photoUrl'];
      // Update the profile image if a new image is selected
      if (_image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_pics').child('${user!.uid}.jpg');
        await storageRef.putFile(_image!);
        photoUrl = await storageRef.getDownloadURL();
      }

      // Update user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'username': _usernameController.text,
        'bio': _bioController.text,
        'photoUrl': photoUrl,
      });

      // Update post documents with the new profile image and new username
      var postDocs = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: user.uid)
          .get();

      for (var doc in postDocs.docs) {
        await doc.reference.update({
          'profImage': photoUrl,
          'username': _usernameController.text,
        });
      }

      // Navigate back after updating the profile
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Method to select an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to delete the user account
  Future<void> _deleteAccount() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
        await user.delete();

        // Redirect to the login screen after deleting the account
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAccount,
          ),
        ],
      ),
      // Display a loading indicator or the profile edit form
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                children: [
                  const SizedBox(height: 44),
                   // Display the profile image
                  _buildProfileImage(),
                  const SizedBox(height: 54),
                  // Text field for the username
                  _buildTextField(_usernameController, 'Username', Icons.person),
                  const SizedBox(height: 26),
                   // Text field for the bio
                  _buildTextField(_bioController, 'Bio', Icons.info),
                  const SizedBox(height: 26),
                  // Text field for the current password
                  _buildTextField(_currentPasswordController, 'Current Password', Icons.lock, obscureText: true),
                  const SizedBox(height: 26),
                   // Text field for the new password
                  _buildTextField(_newPasswordController, 'New Password', Icons.lock_outline, obscureText: true),
                  const SizedBox(height: 26),
                  // Text field for the password confirmation
                  _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock_outline, obscureText: true),
                  const SizedBox(height: 72),
                  SizedBox(
                    width: double.infinity,
                    // Button to update the profile
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 159, 91, 171),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget to display and update the profile image
  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: _image != null ? FileImage(_image!) : NetworkImage(widget.userData['photoUrl']) as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 7,
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _pickImage,
          ),
        ),
        if (_isLoading)
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
      ],
    );
  }

  // Widget to build a text field with specific parameters
  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade200,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purpleAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
