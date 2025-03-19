// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/widgets/bottom_navigation.dart';
// import 'dart:async';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // ⏳ Automatically transition AFTER GIF completes
//     Timer(Duration(seconds: 7), () {
//       // Change to GIF's exact duration
//       if (mounted) {
//         // ✅ Prevent errors if user exits early
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => BottomNavBar()),
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

import 'package:flutter/material.dart';
import 'package:assessment_leeza_app/core/supabase_client.dart';
import 'package:assessment_leeza_app/pages/login_page.dart'; // Correct import
import 'package:assessment_leeza_app/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterGif();
    });
  }

  Future<void> _navigateAfterGif() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) {
      final session = SupabaseClientHelper.supabase.auth.currentSession;
      if (session != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Remove 'const' if LoginPage isn't const
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
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
