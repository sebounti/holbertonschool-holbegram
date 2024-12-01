import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Class to manage post storage methods
  // Method to upload a post
  Future<String> uploadPost(String caption, String uid, String username, String profImage, Uint8List image) async {
    try {
      // Uploads the image to Firebase Storage
      String imageUrl = await StorageMethods().uploadImageToStorage(true, 'posts', image);

      // Creates a unique identifier for the post
      String postId = _firestore.collection('posts').doc().id;

      // Creates a post with the provided details
      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'postUrl': imageUrl,
        'postId': postId,
        'datePublished': DateTime.now(),
        'likes': [],
      });

      // Adds the postId to the 'users' collection
      await _firestore.collection('users').doc(uid).update({
        'posts': FieldValue.arrayUnion([postId]),
      });

      return 'Ok';
    } catch (e) {
      return e.toString();
    }
  }

  // Method to delete a post
  // Deletes the post from the database
  // Removes the postId from the 'users' collection
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();

      // Removes the postId from the 'users' collection
      QuerySnapshot snapshot = await _firestore.collection('users').where('posts', arrayContains: postId).get();
      for (var doc in snapshot.docs) {
        await _firestore.collection('users').doc(doc.id).update({
          'posts': FieldValue.arrayRemove([postId]),
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}
