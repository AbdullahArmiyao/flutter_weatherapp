import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Create a firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create the function to log the user in
  Future<User?> signIn(String email, String password) async {
    // 
    final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  }
  // And this is to create a new user
  Future<User?> register(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  }
  // And this is to signout
  void signOut() => _auth.signOut();
}
