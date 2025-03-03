import 'package:flutter/material.dart';
import 'package:assessment_leeza_app/core/auth_service.dart';
import 'package:assessment_leeza_app/pages/home_page.dart';

class LoginSignupPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login to Continue", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () async {
                bool success = await _authService.signInWithGoogle();
                if (success) {
                  // Navigate to HomePage after a successful sign-in.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sign in failed or was cancelled."),
                    ),
                  );
                }
              },
              icon: Image.asset(
                "assets/images/google.png",
                height: 24,
                width: 24,
              ),
              label: const Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
