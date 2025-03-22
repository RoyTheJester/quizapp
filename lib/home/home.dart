import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, "/about"),
          // style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text("about"),
        ),
      ),
    );
  }
}
