// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'supabase_client.dart';

// class AuthService {
//   final SupabaseClient supabase = SupabaseClientHelper.supabase;

//   Future<String?> signInWithEmail(String email, String password) async {
//     try {
//       final response = await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       if (response.session != null) return null;
//       return "Failed to sign in";
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> requestOtpForSignup({
//     required String name,
//     required String email,
//     required String phone,
//     required String age,
//     required String password,
//   }) async {
//     try {
//       await supabase.auth.signUp(
//         email: email,
//         password: password,
//         data: {'name': name, 'phone': phone, 'age': age},
//       );
//       await supabase.auth.signInWithOtp(
//         email: email,
//       ); // redirectTo is handled in Supabase.initialize
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> verifyOtpAndSignup({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       // Use currentSession instead of getSession
//       if (supabase.auth.currentSession != null) return null;
//       return "Failed to verify OTP or session not found";
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> requestOtp(String email) async {
//     try {
//       await supabase.auth.signInWithOtp(
//         email: email,
//       ); // redirectTo is handled in Supabase.initialize
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> resetPasswordWithOtp({
//     required String email,
//     required String otp,
//     required String newPassword,
//   }) async {
//     try {
//       // Update password directly; OTP verification handled via session
//       await supabase.auth.updateUser(UserAttributes(password: newPassword));
//       if (supabase.auth.currentSession != null) return null;
//       return "Failed to reset password";
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> signOut() async {
//     try {
//       await supabase.auth.signOut();
//       return null;
//     } catch (e) {
//       return "Error signing out: $e";
//     }
//   }

//   bool isAuthenticated() {
//     return supabase.auth.currentSession != null;
//   }
// }

//part 2
// import 'package:assessment_leeza_app/core/supabase_client.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthService {
//   final supabase = SupabaseClientHelper.supabase;

//   Future<String?> signInWithEmail(String email, String password) async {
//     try {
//       await supabase.auth.signInWithPassword(email: email, password: password);
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> requestOtp(String email) async {
//     try {
//       await supabase.auth.signInWithOtp(email: email);
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> resetPasswordWithOtp({
//     required String email,
//     required String otp,
//     required String newPassword,
//   }) async {
//     try {
//       await supabase.auth.verifyOTP(
//         email: email,
//         token: otp,
//         type: OtpType.recovery,
//       );
//       await supabase.auth.updateUser(
//         UserAttributes(password: newPassword),
//       );
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<Map<String, dynamic>> requestOtpForSignup({
//     required String name,
//     required String email,
//     required String phone,
//     required String age,
//     required String password,
//   }) async {
//     try {
//       // Sign out any existing session to avoid conflicts
//       await supabase.auth.signOut();
//       bool emailAlreadyRegistered = false;

//       // Attempt to sign up the user
//       try {
//         await supabase.auth.signUp(
//           email: email,
//           password: password,
//           data: {'name': name, 'phone': phone, 'age': age},
//         );
//       } on AuthException catch (e) {
//         if (e.message.toLowerCase().contains('email already registered')) {
//           emailAlreadyRegistered = true;
//           print("DEBUG: Email already registered, proceeding to send OTP");
//         } else {
//           return {'error': e.message, 'emailAlreadyRegistered': false};
//         }
//       }

//       // Send OTP to the email (for both new and existing users)
//       await supabase.auth.signInWithOtp(email: email);
//       return {
//         'error': null,
//         'emailAlreadyRegistered': emailAlreadyRegistered,
//       };
//     } on AuthException catch (e) {
//       return {'error': e.message, 'emailAlreadyRegistered': false};
//     } catch (e) {
//       return {'error': "Unexpected error: $e", 'emailAlreadyRegistered': false};
//     }
//   }

//   Future<String?> verifyOtpAndSignup({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       await supabase.auth.verifyOTP(
//         email: email,
//         token: otp,
//         type: OtpType.signup,
//       );
//       if (supabase.auth.currentSession == null) {
//         return "Failed to create session after OTP verification";
//       }
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<String?> signOut() async {
//     try {
//       await supabase.auth.signOut();
//       return null;
//     } on AuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }
// }

import 'package:assessment_leeza_app/core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = SupabaseClientHelper.supabase;

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return null;
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
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
        shouldCreateUser: false, // Don't create a new user for password reset
      );
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
      await supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.recovery,
      );
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<Map<String, dynamic>> requestOtpForSignup({
    required String name,
    required String email,
    required String phone,
    required String age,
    required String password,
  }) async {
    try {
      await supabase.auth.signOut();
      bool emailAlreadyRegistered = false;

      try {
        await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'name': name, 'phone': phone, 'age': age},
        );
      } on AuthException catch (e) {
        if (e.message.toLowerCase().contains('email already registered')) {
          emailAlreadyRegistered = true;
          print("DEBUG: Email already registered, proceeding to send OTP");
        } else {
          return {'error': e.message, 'emailAlreadyRegistered': false};
        }
      }

      await supabase.auth.signInWithOtp(email: email);
      return {
        'error': null,
        'emailAlreadyRegistered': emailAlreadyRegistered,
      };
    } on AuthException catch (e) {
      return {'error': e.message, 'emailAlreadyRegistered': false};
    } catch (e) {
      return {'error': "Unexpected error: $e", 'emailAlreadyRegistered': false};
    }
  }

  Future<String?> verifyOtpAndSignup({
    required String email,
    required String otp,
  }) async {
    try {
      await supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.signup,
      );
      if (supabase.auth.currentSession == null) {
        return "Failed to create session after OTP verification";
      }
      return null;
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
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Unexpected error: $e";
    }
  }
}
