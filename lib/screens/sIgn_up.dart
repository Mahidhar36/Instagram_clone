import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/firebase/auth_cubit_state.dart';
import 'package:instagram_clone/screens/home_screen.dart';
class SignUpScreen extends StatefulWidget {
  static  String routname="SignUp";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool visibility=false;
String Username="";
String Email="";
String Password="";
String Bio="";
String ProfilePhoto="";
  late final FocusNode focusNode;

  final formKey=GlobalKey<FormState>();
  final formKey1=GlobalKey<FormState>();
  File? _imageFile;
  ImageProvider<Object>? _imageProvider;

  @override
  void initState() {
    super.initState();
    _imageProvider = const AssetImage("lib/assets/images.png");
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        ProfilePhoto=pickedImage.path;
        _imageFile = File(pickedImage.path);
        _imageProvider = FileImage(_imageFile!);

      });
    }
  }

  void submit(){
    if(!formKey.currentState!.validate()){
      return ;
    }formKey.currentState!.save();
    context.read<AuthCubit>().SignUo(Username: Username, Email: Email, Password: Password, Bio: Bio, ProfilePhoto: ProfilePhoto);
    FocusScope.of(context).unfocus();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(


          body:SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<AuthCubit,AuthState>(
              listener: (prev,cur){
                if(cur is AuthError){
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(cur.message),duration: const Duration(seconds: 2),));
                }
                if(cur is AuthSignedUp){
                  Navigator.of(context).pushReplacementNamed(HomeScreen.route);
                }
              },
              builder: (context,state){
                if(State is AuthLoading){
                  return Center(child:CircularProgressIndicator());
                }
                else{
                  return Form(
                      key:formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(

                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,

                            children:[

                              Stack(
                                  children: [  CircleAvatar(
                                    radius: 85,
                                    backgroundImage: _imageProvider,

                                  ),
                                    Positioned(right: -10,left: 100,bottom:0,child:IconButton(
                                      onPressed: () {
                                        _pickImage();

                                      }, icon: Icon(Icons.add_a_photo),
                                    ),),
                                  ]),

                              SizedBox(height: 30,),
                              TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(

                                    ),
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "Enter Username"
                                ),
                                onSaved: (value){
                                  Username=value!.trim();
                                },

                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Username";
                                  }
                                },
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 10,),

                              TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email),
                                    hintText: "Enter EmailAddress"
                                ),
                                onSaved: (value){
                                  Email=value!.trim();
                                },

                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter the EmailAddress";
                                  }
                                },
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                obscureText: visibility,
                                decoration:  InputDecoration(
                                  border:const  OutlineInputBorder(),
                                  prefixIcon:const  Icon(Icons.lock),
                                  hintText: "Enter Password",
                                  suffixIcon:InkWell(
                                    onTap:(){
                                      setState(() {
                                        visibility=!visibility;
                                      });
                                    },

                                    child: visibility ? const Icon(Icons.visibility_off):const Icon(Icons.visibility),
                                  ),
                                ),

                                onSaved: (value){
                                  Password=value!.trim();
                                },
                                validator: (value){
                                  if(value==null|| value.isEmpty){
                                    return "Please Enter the Password";
                                  }
                                },
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                textInputAction: TextInputAction.done,
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "Enter Bio"
                                ),
                                onSaved: (value){
                                  Bio=value!.trim();
                                },

                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "PLease Enter Your Bio";
                                  }
                                },
                                onFieldSubmitted: (_)=> submit(),
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 25,),

                              MaterialButton(onPressed: (){
                                FocusScope.of(context).unfocus();
                                submit();
                              },color: Colors.blue,minWidth: 500,child:const Text("SignUp"),),

                            ]
                        ),

                      ),

                    );
                }
              },
            ),
          )
      ),
    );
  }
}
