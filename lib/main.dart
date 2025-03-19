// import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:assessment_leeza_app/core/supabase_client.dart';
// import 'package:assessment_leeza_app/screens/splash_screen.dart';
// import 'themes.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   await SupabaseClientHelper.initialize();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Leeza.app',
//       debugShowCheckedModeBanner: false,
//       theme: appTheme,
//       home: SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:assessment_leeza_app/core/supabase_client.dart';
import 'package:assessment_leeza_app/screens/splash_screen.dart';
import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientHelper.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leeza.app',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/auth-callback') {
          final uri = Uri.parse(settings.arguments as String);
          return MaterialPageRoute(builder: (context) => SplashScreen());
        }
        return null;
      },
    );
  }
}
