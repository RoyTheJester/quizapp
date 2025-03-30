import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// There are two ways to implement authentication in Flutter:
// using Firebase Authentication or using a custom backend.
class AuthService {
  // The first way is a stream that listens to authentication changes.
  // Useful for real-time updates and can be used to show different screens
  // based on the authentication state.
  final userStream = FirebaseAuth.instance.authStateChanges();

  // The second way is to get the user synchronously.
  // This is useful when you have an event like a button press and you want
  // to check if the user is logged in or not.
  final user = FirebaseAuth.instance.currentUser;
}
