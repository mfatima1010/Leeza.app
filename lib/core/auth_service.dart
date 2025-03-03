import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'supabase_client.dart'; // Ensure correct import

class AuthService {
  final SupabaseClient supabase = SupabaseClientHelper.supabase;

  // Google Sign-In Method
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

      // Use OAuthProvider.google
      final AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      if (response.session != null) {
        print("✅ Successfully signed in: ${response.session?.user?.email}");
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

  // Sign Out Method
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      print("✅ Signed out successfully.");
    } catch (e) {
      print("⚠️ Error during sign out: $e");
    }
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return supabase.auth.currentSession != null;
  }
}
