import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

// Class to manage authentication methods
class AuthMethods {
  // Initialization of FirebaseAuth and FirebaseFirestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User login method
  Future<String> login({
    required String email,
    required String password,
  }) async {
    // Check that fields are not empty
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }

    try {
      // Login with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      // In case of error, return the error message
      return e.toString();
    }
  }

  // User signup method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    // Check that fields are not empty and that the file is provided
    if (email.isEmpty || password.isEmpty || username.isEmpty || file == null) {
      return 'Please fill all the fields';
    }

    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      // Check that the user was created successfully
      if (user == null) {
        return 'User creation failed';
      }

      // Upload profile image and retrieve the URL
      String photoUrl = await StorageMethods().uploadImageToStorage(
        false,
        'profilePics',
        file,
      );

      // Create a new user instance with the provided information
      Users newUser = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username[0].toUpperCase(),
      );

      // Save the user in the Firestore collection
      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

      return 'success';
    } catch (e) {
      // In case of error, return the error message
      return e.toString();
    }
  }

  // Method to get the details of the currently logged-in user
  Future<Users> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    // Check that a user is currently logged in
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    // Retrieve user information from Firestore
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    if (snap.data() == null) {
      throw Exception('User data is null');
    }

    // Convert data to user instance
    return Users.fromSnap(snap);
  }
}
