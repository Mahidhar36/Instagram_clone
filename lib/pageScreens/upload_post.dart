

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/pageScreens/add_a_post.dart';

class UploadPost extends StatefulWidget {
  static String routname="UploadPost";
  const UploadPost({Key? key}) : super(key: key);

  @override
  State<UploadPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(onPressed: () async{
            final ImagePicker imagePicker = ImagePicker();

            final XFile? xFile = await imagePicker.pickImage(
                source: ImageSource.camera, imageQuality: 50);

            if (xFile != null) {
              Navigator.of(context).pushNamed(AddAPost.routname,arguments: File(xFile.path));
            }

          },child: const Text("Camera",),color: Colors.blue,),
          const SizedBox(height: 20,),
          MaterialButton(onPressed: ()async{
            final ImagePicker imagePicker = ImagePicker();

            final XFile? xFile = await imagePicker.pickImage(
                source: ImageSource.gallery, imageQuality: 50);

            if (xFile != null) {
              Navigator.of(context).pushNamed(AddAPost.routname,arguments: File(xFile.path));
            }
          },child: Text("Gallery"),color: Colors.blue),
        ],
      ),
      ),
    );
  }
}
