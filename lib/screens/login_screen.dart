import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Basically what the controller does is, it allows you to store or use the
  // user input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  // Function to login
  void login() async {
    try {
      // Using user credentials to sign user in...the functions are in the 
      // auth_service file
      final user = await authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      // If user checks out, take him to the homescreen
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } 
    } 
    // Else if there is an error with firebase, provide the error message
    // It's the same concept as creating an account
    on FirebaseAuthException catch (e) {
      String err = "An Error Occured. $e";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
    // If there is any other error, just state it
     catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  void register() async {
    try{
      final user = await authService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      String err = "An Error Occured. $e";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: Theme.of(context).textTheme.headlineMedium),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email')),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Login')),
            ElevatedButton(onPressed: register, child: Text("Register"))
          ],
        ),
      ),
    );
  }
}
