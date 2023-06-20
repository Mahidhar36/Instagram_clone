import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() :super(const AuthInitial());

  Future<void> SignIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthError("No user found for that email."));
      } else if (e.code == 'wrong-password') {
        emit(const AuthError("No user found for that email."));
      }
    }
  }

  Future<void> SignUo({
    required String Username,
    required String Email,
    required String Password,
    required String Bio,
    required String ProfilePhoto
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: Email, password: Password);
      userCredential.user!.updateDisplayName(Username);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("users").doc(userCredential.user!.uid).set({
        "username": Username,
        "Email": Email,
        "Bio": Bio,
        "profilePicture": ProfilePhoto,
        "followers": [],
        "following": []
      });

      emit(const AuthSignedUp());
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const AuthError("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(const AuthError("The account already exists for that email."));
      }
      else if (e.code == 'The given password is invalid') {
        emit(const AuthError("The given password is invalid"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

abstract class AuthState extends Equatable{
  const AuthState();
  @override
  List<Object> get props=> [];

  String get message => message;
}
class AuthInitial extends AuthState{
  const AuthInitial();
}
class AuthLoading extends AuthState{
  const AuthLoading();
}
class AuthSignedIn extends  AuthState{
  const AuthSignedIn();
}
class AuthSignedUp extends  AuthState{
  const AuthSignedUp();
}
class AuthError extends AuthState{
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props =>[message];
}