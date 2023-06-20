import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userid;
  final String username;
   final String commentid;
  final Timestamp datepublished;
  final String text;
  final String postid;
  final String profilephoto;
  final List<dynamic> likes;

  CommentModel(
      {required this.userid,
      required this.username,
      required this.text,
      required this.postid,
      required this.profilephoto,
      required this.likes,
      required this.datepublished,
      required this.commentid});
}
