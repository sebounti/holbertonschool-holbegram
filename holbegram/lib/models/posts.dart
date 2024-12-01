import 'package:cloud_firestore/cloud_firestore.dart';

// Class representing a Post
class Post {
  final String caption;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  // Constructor for the Post class
  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  // Static method to create a Post from a JSON Map
  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      caption: json['caption'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      postId: json['postId'] ?? '',
      datePublished: json['datePublished'] != null
          ? (json['datePublished'] as Timestamp).toDate()
          : DateTime.now(),
      postUrl: json['postUrl'] ?? '',
      profImage: json['profImage'] ?? '',
    );
  }

  // Method to convert a Post to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'likes': likes,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }

  // Method to check if a user has liked the post
  bool isLikedBy(String userId) {
    return likes.contains(userId);
  }

  // Method to get the number of likes
  int get likesCount => likes.length;

  // Method to get the time elapsed since publication
  String get timeAgo {
    final difference = DateTime.now().difference(datePublished);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s)';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s)';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s)';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s)';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s)';
    } else {
      return 'just now';
    }
  }
}
