


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import '../models/post_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(height:120,width:250,child:Image.asset("lib/assets/instagram.png",alignment: Alignment.topLeft,fit: BoxFit.scaleDown,),),
        backgroundColor: Colors.black,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(CommunityMaterialIcons.facebook_messenger, color: Colors.blue),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError || snapshot.connectionState == ConnectionState.none) {
            return const Center(child: Text("Oops, something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
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

                return PostCard(post: post);
              },
            );
          }
        },
      ),
    );
  }
}