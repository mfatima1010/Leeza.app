// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/core/auth_service.dart';
// import 'package:assessment_leeza_app/pages/login_page.dart';
// import 'package:assessment_leeza_app/pages/home_page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({Key? key}) : super(key: key);

//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final AuthService _authService = AuthService();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _otpController = TextEditingController();
//   bool _isLoading = false;
//   bool _otpSent = false;

//   Future<void> _requestOtpForSignup() async {
//     if (_nameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _phoneController.text.isEmpty ||
//         _ageController.text.isEmpty ||
//         _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.requestOtpForSignup(
//       name: _nameController.text.trim(),
//       email: _emailController.text.trim(),
//       phone: _phoneController.text.trim(),
//       age: _ageController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
//     setState(() => _isLoading = false);
//     if (error == null) {
//       setState(() => _otpSent = true);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("OTP sent! Please check your email.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error)));
//     }
//   }

//   Future<void> _verifyOtpAndSignup() async {
//     if (_otpController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter the OTP")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.verifyOtpAndSignup(
//       email: _emailController.text.trim(),
//       otp: _otpController.text.trim(),
//     );
//     setState(() => _isLoading = false);
//     if (error == null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error)));
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _ageController.dispose();
//     _passwordController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F3E3), // Updated background color
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: ListView(
//           children: [
//             const SizedBox(height: 40),
//             if (!_otpSent) ...[
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: "Phone Number",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _ageController,
//                 decoration: const InputDecoration(
//                   labelText: "Age",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//             ],
//             if (_otpSent) ...[
//               const Text(
//                 "Please check your email for the OTP",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _otpController,
//                 decoration: const InputDecoration(
//                   labelText: "Enter OTP",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 24),
//             ],
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : ElevatedButton(
//                     onPressed:
//                         _otpSent ? _verifyOtpAndSignup : _requestOtpForSignup,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white, // White background
//                       foregroundColor: const Color(0xFFCB6CE6), // Pink text
//                       side: const BorderSide(
//                         color: Color(0xFFCB6CE6), // Pink border
//                         width: 2,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(12), // Rounded corners
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 16, // Increased height
//                         horizontal: 24,
//                       ),
//                     ),
//                     child: Text(
//                       _otpSent ? "Verify OTP & Sign Up" : "Send OTP",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Already have an account? "),
//                 TextButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LoginPage()),
//                   ),
//                   child: const Text("Login"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:assessment_leeza_app/core/auth_service.dart';
import 'package:assessment_leeza_app/pages/login_page.dart';
import 'package:assessment_leeza_app/pages/home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;
  bool _emailAlreadyRegistered = false;

  Future<void> _requestOtpForSignup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Show OTP field immediately after clicking "Send OTP"
    setState(() {
      _otpSent = true;
      _isLoading = true;
      print("DEBUG: _otpSent set to $_otpSent (before API call)");
    });

    final result = await _authService.requestOtpForSignup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      age: _ageController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['error'] == null) {
      setState(() {
        _emailAlreadyRegistered = result['emailAlreadyRegistered'] ?? false;
        print(
            "DEBUG: OTP sent successfully, _emailAlreadyRegistered: $_emailAlreadyRegistered");
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _emailAlreadyRegistered
                ? "Email already registered. We’ve sent an OTP to verify your identity."
                : "OTP sent! Please check your email.",
          ),
        ),
      );
    } else {
      // Show error but keep the OTP field visible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
      // Optionally reset _otpSent to false if you want to hide the field on error
      // setState(() => _otpSent = false);
    }
  }

  Future<void> _verifyOtpAndSignup() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP")),
      );
      return;
    }
    setState(() => _isLoading = true);
    final error = await _authService.verifyOtpAndSignup(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (error == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    if (_otpSent) {
      _authService.signOut();
    }
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Building SignupPage, _otpSent = $_otpSent");
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E3),
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            if (!_otpSent) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
            ] else ...[
              const Text(
                "Please check your email for the OTP",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
            ],
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed:
                        _otpSent ? _verifyOtpAndSignup : _requestOtpForSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFCB6CE6),
                      side: const BorderSide(
                        color: Color(0xFFCB6CE6),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                    ),
                    child: Text(
                      _otpSent ? "Verify OTP & Sign Up" : "Send OTP",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
