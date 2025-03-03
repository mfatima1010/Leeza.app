// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;
// final GoogleSignIn _googleSignIn = GoogleSignIn();

// /// Signs in the user with Google and returns the [User] if successful.
// /// Returns null if the user cancels the sign-in flow.
// Future<User?> signInWithGoogle() async {
//   try {
//     // 1. Trigger the Google sign-in flow.
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       // The user canceled the sign-in.
//       return null;
//     }

//     // 2. Obtain the auth details.
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     // 3. Create a new credential.
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     // 4. Sign in with Firebase.
//     final UserCredential userCredential =
//         await _auth.signInWithCredential(credential);

//     // 5. Return the signed-in user.
//     return userCredential.user;
//   } catch (error) {
//     print("Error during Google sign in: $error");
//     return null;
//   }
// }

// /// Signs out the current user from both Firebase and Google.
// Future<void> signOut() async {
//   await _auth.signOut();
//   await _googleSignIn.signOut();
// }

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:assessment_leeza_app/core//supabase_client.dart'; // Ensure your Supabase client setup is correct

class AuthService {
  final SupabaseClient supabase = SupabaseClientHelper.supabase;

  // ✅ Google Sign-In Method
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("❌ Google sign-in was cancelled.");
        return false; // User cancelled login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use AuthResponse and OAuthProvider.google
      final AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      final User? user = response.session?.user; // ✅ Added null safety

      if (user != null) {
        print("✅ Successfully signed in: ${user.email}");
        return true;
      } else {
        print("❌ Google authentication failed.");
        return false;
      }
    } catch (error) {
      print("⚠️ Error signing in with Google: $error");
      return false;
    }
  }

  // ✅ Email & Password Sign-In
  static Future<bool> signIn(String email, String password) async {
    try {
      await SupabaseClientHelper.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  // ✅ Email & Password Sign-Up
  static Future<bool> signUp(String email, String password) async {
    try {
      await SupabaseClientHelper.supabase.auth.signUp(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }

  // ✅ Sign Out Method
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      print("✅ Signed out successfully.");
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  // ✅ Get Current User
  static User? getCurrentUser() {
    return SupabaseClientHelper.supabase.auth.currentUser;
  }

  // ✅ Check Authentication Status
  bool isAuthenticated() {
    return supabase.auth.currentSession != null;
  }
}
