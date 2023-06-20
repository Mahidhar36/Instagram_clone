import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user.dart';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isshow = false;
  String text = "";
  @override
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isshow) {
          setState(() {
            FocusScope.of(context).unfocus();
            isshow = false;
          });
          return false; // Prevent navigating back
        }
        return true; // Allow navigating back
      },
      child: Scaffold(
          appBar: AppBar(

              backgroundColor: Colors.black,

              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.grey,
                ),

                height: 45, width: 350,
                child: TextFormField(
                    onTap: () {
                      setState(() {
                        isshow = true;
                      });
                    },
                    controller: textEditingController,
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                    onFieldSubmitted: (_) {
                      setState(() {
                        isshow = true;
                        FocusScope.of(context).unfocus();
                      });

                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),

                      ),
                      hintText: "Search",
                      prefixIcon: const Icon(
                        Icons.search, size: 25, color: Colors.white,),
                      suffixIcon: IconButton(onPressed: () {
                        textEditingController.clear();
                      }, icon: Icon(Icons.clear, size: 25, color: Colors.white,)),
                    )
                ),
              )
          ),
          body: (isshow) ? FutureBuilder(
              future: FirebaseFirestore.instance.collection("users").where(
                  "username", isGreaterThanOrEqualTo: text).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(),);
                }
                else {
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        final doc = (snapshot.data! as dynamic).docs[index];
                        final UserModal user = UserModal(
                            username: doc["username"] as String,
                            bio: doc["Bio"],
                            emailaddress: doc['Email'],
                            profilephoto: doc['profilePicture'],
                            followers: doc['followers'],
                            following: doc['following']);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(File(
                                    user.profilephoto)),
                              ),
                              title: Text(user.username.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),)
                          ),
                        );
                      });
                }
              }) :StreamBuilder(
              stream: FirebaseFirestore.instance.collection("posts").snapshots(),
              builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                   return Center(child:CircularProgressIndicator());
                }
                else{

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final post = Post(
                        timestamp: doc["timeStamp"] as Timestamp,
                        description: doc["description"] as String,
                        username: doc["userName"] as String,
                        imagrUrl: doc["imageUrl"] as String,
                        userid: doc["userId"] as String,
                        postid: doc["postID"] as String,
                        likes: doc["likes"],
                        profilrphoto: doc["profilephoto"],
                      );
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(post.imagrUrl)
                          )
                        ),
                      );
                    },
                    staggeredTileBuilder:(index)=> StaggeredTile.count(
                        (index%7==0)? 2:1,
                        (index%7==0)? 2:1
                    ),
                   mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  );
                }
              } ),


      ),
    );
  }
}
