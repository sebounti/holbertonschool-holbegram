import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Class to manage storage methods on Firebase
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to upload an image to Firebase storage
  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    try {
      // Reference to the folder in storage with the current user's ID
      Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

      // If it's a post image, add a folder with a unique ID
      if (isPost) {
        String id = const Uuid().v1();
        ref = ref.child(id);
      }

      // Start the upload of the file
      UploadTask uploadTask = ref.putData(file);

      // Wait for the upload to finish and get a snapshot of the task
      TaskSnapshot snapshot = await uploadTask;

      // Retrieve the download URL of the image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error during image upload: $e');
    }
  }
}
