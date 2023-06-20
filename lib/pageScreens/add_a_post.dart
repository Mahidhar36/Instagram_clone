import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/home_screen.dart';

class AddAPost extends StatefulWidget {
  static String routname = "addApost";

  const AddAPost({Key? key}) : super(key: key);

  @override
  State<AddAPost> createState() => _AddAPostState();
}

class _AddAPostState extends State<AddAPost> {
  final _formKey = GlobalKey<FormState>();
  String description = "";

  Future<String?> getUserProfilePicture() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('profilePicture')) {
        return userData['profilePicture'];
      }
    }
  }

  Future<void> _submit(File image) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // Write image to storage
    storage.FirebaseStorage firebaseStorage = storage.FirebaseStorage.instance;
    late String imageUrl;
    await firebaseStorage
        .ref("image/${UniqueKey().toString()}.png")
        .putFile(image)
        .then((taskSnapshot) async {
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    });
    // Add to cloud firestore

    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("posts");

    final profilephoto =await getUserProfilePicture();

    collectionReference.add({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "description": description,
      "timeStamp": Timestamp.now(),
      "userName": FirebaseAuth.instance.currentUser!.displayName,
      "imageUrl": imageUrl,
      "profilephoto": profilephoto.toString(),
      "likes": [],
      "postID": ""
    }).then((docReference) => docReference.update({"postID": docReference.id}));

    // Pop the screen
    Navigator.of(context).pushReplacementNamed(HomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final File image = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add A Post"),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (image != null) Image.file(image, fit: BoxFit.cover),
                TextFormField(
                  onSaved: (value) {
                    description = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide description";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  )),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                ),
                MaterialButton(
                  onPressed: () {
                    _submit(image);
                    FocusScope.of(context).unfocus();
                  },
                  child: Text("Post"),
                )
              ],
            )));
  }
}
