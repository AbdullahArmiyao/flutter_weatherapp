// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import 'home_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final authService = AuthService();

//   void register() async {
//     final user = await authService.register(
//       emailController.text,
//       passwordController.text,
//     );
//     if (user != null) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Register', style: Theme.of(context).textTheme.headlineMedium),
//             TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
//             TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: register, child: Text('Register')),
//           ],
//         ),
//       ),
//     );
//   }
// }
