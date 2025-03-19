// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'supabase_client.dart'; // Ensure correct import

// class AuthService {
//   final SupabaseClient supabase = SupabaseClientHelper.supabase;

//   // Google Sign-In Method
//   Future<bool> signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser == null) {
//         print("❌ Google sign-in was cancelled.");
//         return false; // User cancelled login
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Use OAuthProvider.google
//       final AuthResponse response = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//       );

//       if (response.session != null) {
//         print("✅ Successfully signed in: ${response.session?.user?.email}");
//         return true;
//       } else {
//         print("❌ Google authentication failed.");
//         return false;
//       }
//     } catch (error) {
//       print("⚠️ Error signing in with Google: $error");
//       return false;
//     }
//   }

//   // Sign Out Method
//   Future<void> signOut() async {
//     try {
//       await supabase.auth.signOut();
//       print("✅ Signed out successfully.");
//     } catch (e) {
//       print("⚠️ Error during sign out: $e");
//     }
//   }

//   // Check if user is authenticated
//   bool isAuthenticated() {
//     return supabase.auth.currentSession != null;
//   }
// }

//2nd
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'supabase_client.dart';

// class AuthService {
//   final SupabaseClient supabase = SupabaseClientHelper.supabase;

//   /// Signs up a new user using email and password.
//   /// Extra user details (name, phone, age) are stored as metadata.
//   Future<bool> signUpWithEmail({
//     required String name,
//     required String email,
//     required String phone,
//     required String age,
//     required String password,
//   }) async {
//     try {
//       final response = await supabase.auth.signUp(
//         email: email,
//         password: password,
//         data: {
//           'name': name,
//           'phone': phone,
//           'age': age,
//         },
//       );
//       if (response.user != null) {
//         print("✅ Sign up successful: ${response.user!.email}");
//         return true;
//       } else {
//         print("❌ Sign up failed: Unknown error");
//         return false;
//       }
//     } catch (e) {
//       print("⚠️ Error during sign up: $e");
//       return false;
//     }
//   }

//   /// Signs in an existing user using email and password.
//   Future<bool> signInWithEmail(String email, String password) async {
//     try {
//       final response = await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       if (response.session != null) {
//         print("✅ Sign in successful: ${response.session!.user!.email}");
//         return true;
//       } else {
//         print("❌ Sign in failed: Unknown error");
//         return false;
//       }
//     } catch (e) {
//       print("⚠️ Error during sign in: $e");
//       return false;
//     }
//   }

//   /// Signs out the current user.
//   Future<void> signOut() async {
//     try {
//       await supabase.auth.signOut();
//       print("✅ Signed out successfully.");
//     } catch (e) {
//       print("⚠️ Error during sign out: $e");
//     }
//   }

//   /// Checks if the user is currently authenticated.
//   bool isAuthenticated() {
//     return supabase.auth.currentSession != null;
//   }
// }

//3rd

// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'supabase_client.dart';

// class AuthService {
//   final SupabaseClient supabase = SupabaseClientHelper.supabase;

//   /// Signs in with email and password
//   Future<String?> signInWithEmail(String email, String password) async {
//     try {
//       final response = await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       if (response.session != null) {
//         return null; // Success
//       }
//       return "Failed to sign in";
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   /// Requests an OTP for signup (also stores user data)
//   Future<String?> requestOtpForSignup({
//     required String name,
//     required String email,
//     required String phone,
//     required String age,
//     required String password,
//   }) async {
//     try {
//       // Sign up the user (this stores the user data)
//       await supabase.auth.signUp(
//         email: email,
//         password: password,
//         data: {
//           'name': name,
//           'phone': phone,
//           'age': age,
//         },
//       );

//       // Request OTP for verification
//       await supabase.auth.signInWithOtp(
//         email: email,
//       );
//       return null; // Success
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   /// Verifies OTP and completes signup (auto-logs in)
//   Future<String?> verifyOtpAndSignup({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       final response = await supabase.auth.verifyOTP(
//         email: email,
//         token: otp,
//         type: OtpType.signup,
//       );
//       if (response.session != null) {
//         return null; // Success, user is logged in
//       }
//       return "Failed to verify OTP";
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   /// Requests an OTP for password reset
//   Future<String?> requestOtp(String email) async {
//     try {
//       await supabase.auth.signInWithOtp(
//         email: email,
//         emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
//       );
//       return null; // Success
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   /// Resets password with OTP
//   Future<String?> resetPasswordWithOtp({
//     required String email,
//     required String otp,
//     required String newPassword,
//   }) async {
//     try {
//       // Verify the OTP
//       await supabase.auth.verifyOTP(
//         email: email,
//         token: otp,
//         type: OtpType.recovery,
//       );

//       // Update the password
//       await supabase.auth.updateUser(
//         UserAttributes(password: newPassword),
//       );
//       return null; // Success
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   /// Signs out the current user
//   Future<String?> signOut() async {
//     try {
//       await supabase.auth.signOut();
//       return null; // Success
//     } catch (e) {
//       return "Error signing out: $e";
//     }
//   }

//   /// Checks if the user is authenticated
//   bool isAuthenticated() {
//     return supabase.auth.currentSession != null;
//   }
// }

import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthService {
  final SupabaseClient supabase = SupabaseClientHelper.supabase;

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) return null;
      return "Failed to sign in";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String?> requestOtpForSignup({
    required String name,
    required String email,
    required String phone,
    required String age,
    required String password,
  }) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone, 'age': age},
      );
      await supabase.auth.signInWithOtp(
        email: email,
      ); // redirectTo is handled in Supabase.initialize
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String?> verifyOtpAndSignup({
    required String email,
    required String otp,
  }) async {
    try {
      // Use currentSession instead of getSession
      if (supabase.auth.currentSession != null) return null;
      return "Failed to verify OTP or session not found";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String?> requestOtp(String email) async {
    try {
      await supabase.auth.signInWithOtp(
        email: email,
      ); // redirectTo is handled in Supabase.initialize
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String?> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // Update password directly; OTP verification handled via session
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
      if (supabase.auth.currentSession != null) return null;
      return "Failed to reset password";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String?> signOut() async {
    try {
      await supabase.auth.signOut();
      return null;
    } catch (e) {
      return "Error signing out: $e";
    }
  }

  bool isAuthenticated() {
    return supabase.auth.currentSession != null;
  }
}
