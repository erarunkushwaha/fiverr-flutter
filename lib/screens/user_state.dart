import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/screens/jobs_screen.dart';
import 'package:fiverr/screens/login_screen.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          return const LoginScreen();
        } else if (userSnapshot.hasData) {
          return const JobsScreen();
        } else if (userSnapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("An error occured")),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const Scaffold(
          body: Center(child: Text("something went wring")),
        );
      },
    );
  }
}
