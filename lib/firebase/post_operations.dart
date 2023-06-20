

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';

class PostOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> AddLikePost(String postid, String userid,
      List<dynamic>like) async {
    String error = "some error occured";
    try {
      if (!like.contains(userid)) {
        like.add(userid);


        await _firestore.collection("posts").doc(postid).update(
            {"likes": like});
      }
      else {
        return;
      }
    }
    catch (e) {
      error = e.toString();
    }
  }

  Future<void> removeLikePost(String postid, String userid,
      List<dynamic>like) async {
    String error = "some error occured";
    try {
      if (like.contains(userid)) {
        like.remove(userid);


        await _firestore.collection("posts").doc(postid).update(
            {"likes": like});
      }
      else {
        return;
      }
    }
    catch (e) {
      error = e.toString();
    }
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilephoto': profilePic,
          'username': name,
          'postid':postId,
          'userid': uid,
          'text': text,
          'commentid': commentId,
          'datepublished': DateTime.now(),
          'likes':[] ,
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> AddLikeComment(String commentid,String postid, String userid,
      List<dynamic>likes) async {
    String error = "some error occured";
    try {
      if (!likes.contains(userid)) {
        likes.add(userid);



        await _firestore.collection("posts").doc(postid).collection('comments').doc(commentid).update(
            {"likes": likes});
      }
      else {
        return;
      }
    }
    catch (e) {
      error = e.toString();
    }
  }

  Future<void> removeLikeComment(String postid,String commentid, String userid,
      List<dynamic>likes) async {
    String error = "some error occured";
    try {
      if (likes.contains(userid)) {
        likes.remove(userid);


        await _firestore.collection("posts").doc(postid).collection('comments').doc(commentid).update(
            {"likes": likes});
      }
      else {
        return;
      }
    }
    catch (e) {
      error = e.toString();
    }
  }

Future<void> follow(String postuserid) async{
    List<dynamic>followers;
    List<dynamic>following;
    final userid=FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection("users").doc(postuserid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final userDoc1 = await FirebaseFirestore.instance.collection("users").doc(userid).get();
    final userData1 = userDoc1.data() as Map<String, dynamic>;
    followers=userData['followers'];
    following=userData1['following'];
    if(!followers.contains(userid) && !following.contains(postuserid)){
       followers.add(userid);
       following.add(postuserid);
    }
    await _firestore.collection("users").doc(postuserid).update(
        {"followers": followers});
    await _firestore.collection("users").doc(userid).update(
        {"following": following});

}
  Future<void> unfollow(String postuserid) async{
    List<dynamic>followers;
    List<dynamic>following;
    final userid=FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection("users").doc(postuserid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final userDoc1 = await FirebaseFirestore.instance.collection("users").doc(userid).get();
    final userData1 = userDoc1.data() as Map<String, dynamic>;
    followers=userData['followers'];
    following=userData1['following'];
    if(followers.contains(userid) && following.contains(postuserid)){
      followers.remove(userid);
      following.remove(postuserid);
    }
    await _firestore.collection("users").doc(postuserid).update(
        {"followers": followers});
    await _firestore.collection("users").doc(userid).update(
        {"following": following});

  }


}



