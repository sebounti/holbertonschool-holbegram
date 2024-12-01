import 'package:cloud_firestore/cloud_firestore.dart';

//  Classe représentant un Post (Publication)
class Post {
  final String caption;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  // Constructeur de la classe Post
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

  // Méthode statique pour créer un Post à partir d'un Map JSON
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

  // Méthode pour convertir un Post en Map JSON
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

  // Ajout d'une méthode pour vérifier si un utilisateur a liké le post
  bool isLikedBy(String userId) {
    return likes.contains(userId);
  }

  // Ajout d'une méthode pour obtenir le nombre de likes
  int get likesCount => likes.length;

  // Ajout d'une méthode pour obtenir le temps écoulé depuis la publication
  String get timeAgo {
    final difference = DateTime.now().difference(datePublished);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} an(s)';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mois';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} jour(s)';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure(s)';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s)';
    } else {
      return 'à l\'instant';
    }
  }
}
