import 'package:flutter/material.dart';
import 'package:assessment_leeza_app/widgets/bottom_navigation.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Automatically transition AFTER GIF completes
    Timer(Duration(seconds: 7), () {
      // Change to GIF's exact duration
      if (mounted) {
        // ✅ Prevent errors if user exits early
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(
            'assets/images/splash.gif',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/pages/login_signup.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Automatically transition AFTER the splash duration (e.g., 7 seconds).
//     Timer(Duration(seconds: 7), () {
//       if (mounted) {
//         // Navigate to the login/signup page for Google Sign-In.
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => LoginSignupPage()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: FittedBox(
//           fit: BoxFit.cover,
//           child: Image.asset(
//             'assets/images/splash.gif',
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//           ),
//         ),
//       ),
//     );
//   }
// }
