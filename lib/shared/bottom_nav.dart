import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.graduationCap, size: 20),
          label: 'Topics',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.bolt, size: 20),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user, size: 20),
          label: 'Profile',
        ),
      ],
      fixedColor: Colors.deepPurple[200],
      onTap: (int index) {
        // Define a list of routes corresponding to the BottomNavigationBar items
        const routes = ['/topics', '/about', '/profile'];

        // Get the current route name
        String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

        // Navigate to the selected route if it's not the current route
        if (currentRoute != routes[index]) {
          Navigator.pushNamed(context, routes[index]);
        }
      },
    );
  }
}
