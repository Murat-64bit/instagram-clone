
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String description;
  final String username;
  final datePublished;
  final String profImage;
  final String commentId;
  final likes;

  const Comment({
    required this.description,
    required this.username,
    required this.datePublished,
    required this.profImage,
    required this.commentId,
    required this.likes,
  });

  Map<String, dynamic> toJson()=>{
    "description": description,
    "username":username,
    "datePublished":datePublished,
    "profImage":profImage,
    "commentId":commentId,
    "likes":likes,
  };

  static Comment fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      description: snapshot["description"],
      username: snapshot["username"],
      datePublished: snapshot["datePublished"],
      profImage: snapshot["profImage"],
      commentId: snapshot["commentId"],
      likes: snapshot["likes"],
    );
  }
}