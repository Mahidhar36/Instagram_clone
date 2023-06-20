import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post_operations.dart';
import '../models/comment_model.dart';


class CommentCard extends StatefulWidget {
  final CommentModel comment;

  const CommentCard({required this.comment, Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  bool isfav = false;


  void commenting(bool isfav1) {
    if (!isfav1) {
      final PostOperations postoperations = PostOperations();
      postoperations.removeLikeComment(
          widget.comment.toString(),
          widget.comment.commentid.toString(),
          FirebaseAuth.instance.currentUser!.uid.toString(),
          widget.comment.likes);
    } else {
      final PostOperations postoperations = PostOperations();
      postoperations.AddLikeComment(
          widget.comment.commentid,
          widget.comment.postid.toString(),
          FirebaseAuth.instance.currentUser!.uid.toString(),
          widget.comment.likes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical:1,horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: FileImage(File(widget.comment.profilephoto)),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  RichText(
                    text: TextSpan(
                      children: [

                        TextSpan(
                            text: widget.comment.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),

                        TextSpan(
                          text:widget.comment.datepublished.toDate().toString(),
                          style: const TextStyle(color: Colors.grey,fontSize:12)

                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                     child: Text(
                       widget.comment.text,
                       style: const TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.w400,

                       ),

                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isfav = !isfav;
                        });

                        commenting(isfav);
                      },
                      icon: (!widget.comment.likes
                              .contains(FirebaseAuth.instance.currentUser!.uid))
                           ? const Icon(Icons.favorite_outline, size: 20)
                          : const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 15,
                            )),
                  (widget.comment.likes.isNotEmpty)? Text(widget.comment.likes.length.toString()):Container(),
                ],
              ))
        ],
      ),
    );
  }
}
