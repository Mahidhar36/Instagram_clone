import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/firebase/auth_cubit_state.dart';
import 'package:instagram_clone/pageScreens/add_a_post.dart';
import 'package:instagram_clone/pageScreens/hom_page.dart';
import 'package:instagram_clone/pageScreens/upload_post.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/sIgn_up.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme:ThemeData.dark(),
        home: buildhomescreen(),
        routes: {
          SignUpScreen.routname: (context)=>const SignUpScreen(),
          LogInScreen.route:(context) => const LogInScreen(),
          HomeScreen.route:(context)=> const HomeScreen(),
          UploadPost.routname:(context)=>const UploadPost(),
          AddAPost.routname:(context)=>const AddAPost(),

        },
      ),
    );
  }
}
Widget buildhomescreen(){

  return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return const HomeScreen();
        }
        else{
          return const LogInScreen();
        }
      }
  );
}
