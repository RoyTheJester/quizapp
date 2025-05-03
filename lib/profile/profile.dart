import 'package:flutter/material.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/shared/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ElevatedButton(
        child: Text("Sign out"),
        onPressed: () async {
          await AuthService().signOut();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
