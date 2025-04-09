import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Create a firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create the function to log the user in
  Future<User?> signIn(String email, String password) async {
    //
    final userCred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCred.user;
  }

  // And this is to create a new user
  Future<User?> register(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCred.user;
  }

  // Sign in with google option
  Future<User?> googlelogin() async {
    GoogleAuthProvider gap = GoogleAuthProvider();
    final UserCredential userCred = await _auth.signInWithProvider(gap);
    return userCred.user;
  }

  // And this is to signout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
