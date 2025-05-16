import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user;
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName ?? 'Guest'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(FontAwesomeIcons.faceSmileBeam, size: 80),
              Column(
                children: [
                  Text(report.total.toString(), style: TextStyle(fontSize: 80)),
                  Text("Quizzes completed"),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Text("Logout", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Guest'), backgroundColor: Colors.deepPurple),

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
