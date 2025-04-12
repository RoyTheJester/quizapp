import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // Anonymous Firebase login
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // Handle error
      print('Error signing in anonymously: ${e.message}');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      // Handle error
      print('Error signing out: ${e.message}');
    }
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }
      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      // Handle error
    }
  }
}
