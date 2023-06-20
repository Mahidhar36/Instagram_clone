import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post_operations.dart';
import 'package:instagram_clone/pageScreens/comments_page.dart';

import '../animations/like_animation.dart';
import '../models/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({required this.post, Key? key}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  final userid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          // ... your existing code ...
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CircleAvatar(
                backgroundImage: FileImage(File(post.profilrphoto)),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(post.username),
            ]),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).showBottomSheet(
                        (BuildContext context) {
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            child: Container(
                              height: 200,
                              width: 400,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(post.profilrphoto)),
                                    radius: 40,
                                  ),
                                  Text(
                                    post.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Row(
                                      children: [
                                        (post.userid == userid)
                                            ? MaterialButton(
                                                onPressed: () {
                                                  final PostOperations
                                                      postoperations =
                                                      PostOperations();
                                                  postoperations
                                                      .deletePost(post.postid);
                                                  Navigator.of(context).pop();
                                                },
                                                color: Colors.blueAccent,
                                                child: const Text(
                                                  "share",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : MaterialButton(
                                                onPressed: () {
                                                  final PostOperations
                                                      postoperrations =
                                                      PostOperations();
                                                  postoperrations
                                                      .follow(post.userid);
                                                  Navigator.of(context).pop();
                                                },
                                                color: Colors.blueAccent,
                                                child: const Text(
                                                  "follow ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                        const SizedBox(width: 120),
                                        (post.userid == userid)
                                            ? MaterialButton(
                                                onPressed: () {
                                                  final PostOperations
                                                      postoperations =
                                                      PostOperations();
                                                  postoperations
                                                      .deletePost(post.postid);
                                                  Navigator.of(context).pop();
                                                },
                                                color: Colors.blueAccent,
                                                child: const Text(
                                                  "delete",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : MaterialButton(
                                                onPressed: () {},
                                                color: Colors.blueAccent,
                                                child: const Text(
                                                  "save",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            )
          ]),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                PostOperations postoerations = PostOperations();
                postoerations.AddLikePost(post.postid, userid, post.likes);
                setState(() {
                  isLikeAnimating = true;
                });
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(post.imagrUrl)),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 300),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 80),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                LikeAnimation(
                  isAnimating: post.likes.contains(userid) ? false : true,
                  smallLike: true,
                  child: IconButton(
                    onPressed: () {
                      PostOperations postoperations = PostOperations();

                      (!post.likes.contains(userid))
                          ? postoperations.AddLikePost(
                              post.postid, userid, post.likes)
                          : postoperations.removeLikePost(
                              post.postid, userid, post.likes);
                    },
                    icon: (post.likes.contains(userid))
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_outline),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contetx) => CommentPage(post: post)));
                  },
                  icon: const Icon(
                    FeatherIconsSnakeCase.message_circle,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FeatherIcons.send),
                ),
                const SizedBox(
                  width: 8,
                ),
              ]),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.bookmark_border))
                ],
              )
            ],
          ),
          //
          // ... your existing code ...
          (widget.post.likes.isNotEmpty)
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.w800),
                          child: Text(
                            '${widget.post.likes.length} likes',
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                    ],
                  ),
                )
              : Container(),
        ]));
  }
}
