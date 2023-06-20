import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post_operations.dart';
import 'package:instagram_clone/models/comment_model.dart';

import '../models/post_model.dart';
import '../widgets/comment_card.dart';

class CommentPage extends StatefulWidget {
  final Post post;
  static String routname = "comments_screen";

  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String text = "";
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post.postid)
            .collection('comments').orderBy('datepublished')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                final doc = snapshot.data!.docs[index];
                final CommentModel commentmodel = CommentModel(
                    userid: doc['userid'] as String,
                    username: doc['username'] as String,
                    text: doc['text'] as String,
                    postid: doc['postid'] as String,
                    profilephoto: doc['profilephoto'] as String,
                    likes: doc['likes'],
                    datepublished: doc["datepublished"] as Timestamp,
                     commentid: doc['commentid']);
                return CommentCard(comment: commentmodel,);
              });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CircleAvatar(
             backgroundImage: FileImage(File(widget.post.profilrphoto)),
            ),
            SizedBox.fromSize(
              size: Size(10, 10),
            ),
            Expanded(
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(hintText: "Add a Comment"),
                onChanged: (value) {
                  text = value;
                },
              ),
            ),
            TextButton(
              onPressed: () {
                final PostOperations postoperations = PostOperations();
                postoperations.postComment(
                    widget.post.postid,
                    text,
                    widget.post.userid,
                    widget.post.username,
                    widget.post.profilrphoto);
                textEditingController.clear();
              },
              child: Text(
                "post",
                style: TextStyle(color: Colors.blueAccent),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
