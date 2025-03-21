// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/core/auth_service.dart';
// import 'package:assessment_leeza_app/pages/signup_page.dart';
// import 'package:assessment_leeza_app/pages/home_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final AuthService _authService = AuthService();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _otpController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   bool _isLoading = false;
//   bool _isForgotPassword = false;
//   bool _otpSent = false;
//   String? _emailForReset;

//   Future<void> _handleLogin() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter email and password")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.signInWithEmail(
//       _emailController.text.trim(),
//       _passwordController.text.trim(),
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

//   Future<void> _requestOtpForReset() async {
//     if (_emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter your email")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.requestOtp(_emailController.text.trim());
//     setState(() => _isLoading = false);
//     if (error == null) {
//       setState(() {
//         _otpSent = true;
//         _emailForReset = _emailController.text.trim();
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("OTP sent! Please check your email.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error)));
//     }
//   }

//   Future<void> _verifyOtpAndResetPassword() async {
//     if (_otpController.text.isEmpty || _newPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter OTP and new password")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.resetPasswordWithOtp(
//       email: _emailForReset!,
//       otp: _otpController.text.trim(),
//       newPassword: _newPasswordController.text.trim(),
//     );
//     setState(() => _isLoading = false);
//     if (error == null) {
//       setState(() {
//         _isForgotPassword = false;
//         _otpSent = false;
//         _emailController.clear();
//         _passwordController.clear();
//         _otpController.clear();
//         _newPasswordController.clear();
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Password reset successful! Please log in.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error)));
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _otpController.dispose();
//     _newPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: ListView(
//           children: [
//             const SizedBox(height: 40),
//             if (!_otpSent || !_isForgotPassword) ...[
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
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _handleLogin, child: const Text("Login")),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () => setState(() => _isForgotPassword = true),
//                 child: const Text("Forgot Password?"),
//               ),
//             ],
//             if (_isForgotPassword && _otpSent) ...[
//               const Text("Please check your email for the OTP",
//                   style: TextStyle(
//                       color: Colors.blue, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _otpController,
//                 decoration: const InputDecoration(
//                   labelText: "Enter OTP",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _newPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: "New Password",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _verifyOtpAndResetPassword,
//                       child: const Text("Reset Password")),
//             ] else if (_isForgotPassword) ...[
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _requestOtpForReset,
//                       child: const Text("Send OTP for Password Reset")),
//             ],
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don’t have an account? "),
//                 TextButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SignupPage()),
//                   ),
//                   child: const Text("Sign Up"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//PART- EFFICIENT
// import 'package:flutter/material.dart';
// import 'package:assessment_leeza_app/core/auth_service.dart';
// import 'package:assessment_leeza_app/pages/signup_page.dart';
// import 'package:assessment_leeza_app/pages/home_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final AuthService _authService = AuthService();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _otpController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   bool _isLoading = false;
//   bool _isForgotPassword = false;
//   bool _otpSent = false;
//   String? _emailForReset;

//   Future<void> _handleLogin() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter email and password")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.signInWithEmail(
//       _emailController.text.trim(),
//       _passwordController.text.trim(),
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

//   Future<void> _requestOtpForReset() async {
//     if (_emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter your email")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.requestOtp(_emailController.text.trim());
//     setState(() => _isLoading = false);
//     if (error == null) {
//       setState(() {
//         _otpSent = true;
//         _emailForReset = _emailController.text.trim();
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("OTP sent! Please check your email.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error)));
//     }
//   }

//   Future<void> _verifyOtpAndResetPassword() async {
//     if (_otpController.text.isEmpty || _newPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter OTP and new password")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     final error = await _authService.resetPasswordWithOtp(
//       email: _emailForReset!,
//       otp: _otpController.text.trim(),
//       newPassword: _newPasswordController.text.trim(),
//     );
//     setState(() => _isLoading = false);
//     if (error == null) {
//       setState(() {
//         _isForgotPassword = false;
//         _otpSent = false;
//         _emailController.clear();
//         _passwordController.clear();
//         _otpController.clear();
//         _newPasswordController.clear();
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Password reset successful! Please log in.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error)));
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _otpController.dispose();
//     _newPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F3E3), // Updated background color
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: ListView(
//           children: [
//             const SizedBox(height: 40),
//             if (!_otpSent || !_isForgotPassword) ...[
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
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _handleLogin,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white, // White background
//                         foregroundColor: const Color(0xFFCB6CE6), // Pink text
//                         side: const BorderSide(
//                           color: Color(0xFFCB6CE6), // Pink border
//                           width: 2,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(12), // Rounded corners
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 16, // Increased height
//                           horizontal: 24,
//                         ),
//                       ),
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () => setState(() => _isForgotPassword = true),
//                 child: const Text("Forgot Password?"),
//               ),
//             ],
//             if (_isForgotPassword && _otpSent) ...[
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
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _newPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: "New Password",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _verifyOtpAndResetPassword,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white, // White background
//                         foregroundColor: const Color(0xFFCB6CE6), // Pink text
//                         side: const BorderSide(
//                           color: Color(0xFFCB6CE6), // Pink border
//                           width: 2,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(12), // Rounded corners
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 16, // Increased height
//                           horizontal: 24,
//                         ),
//                       ),
//                       child: const Text(
//                         "Reset Password",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//             ] else if (_isForgotPassword) ...[
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _requestOtpForReset,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white, // White background
//                         foregroundColor: const Color(0xFFCB6CE6), // Pink text
//                         side: const BorderSide(
//                           color: Color(0xFFCB6CE6), // Pink border
//                           width: 2,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(12), // Rounded corners
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 16, // Increased height
//                           horizontal: 24,
//                         ),
//                       ),
//                       child: const Text(
//                         "Send OTP for Password Reset",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//             ],
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don’t have an account? "),
//                 TextButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SignupPage()),
//                   ),
//                   child: const Text("Sign Up"),
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
import 'package:assessment_leeza_app/pages/signup_page.dart';
import 'package:assessment_leeza_app/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isForgotPassword = false;
  bool _otpSent = false;
  String? _emailForReset;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }
    setState(() => _isLoading = true);
    final error = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
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

  Future<void> _requestOtpForReset() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    // Show OTP and new password fields immediately
    setState(() {
      _otpSent = true;
      _isLoading = true;
      _emailForReset = _emailController.text.trim();
      print("DEBUG: _otpSent set to $_otpSent (before API call)");
    });

    final error = await _authService.requestOtp(_emailController.text.trim());
    setState(() => _isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent! Please check your email.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      // Keep the OTP field visible even if there's an error
    }
  }

  Future<void> _verifyOtpAndResetPassword() async {
    if (_otpController.text.isEmpty || _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter OTP and new password")),
      );
      return;
    }
    setState(() => _isLoading = true);
    final error = await _authService.resetPasswordWithOtp(
      email: _emailForReset!,
      otp: _otpController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (error == null) {
      setState(() {
        _isForgotPassword = false;
        _otpSent = false;
        _emailController.clear();
        _passwordController.clear();
        _otpController.clear();
        _newPasswordController.clear();
        _emailForReset = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password reset successful! Please log in.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          action: error.contains("expired") || error.contains("invalid")
              ? SnackBarAction(
                  label: "Resend OTP",
                  onPressed: _requestOtpForReset,
                )
              : null,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E3),
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            if (!_isForgotPassword) ...[
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
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _isForgotPassword = true),
                  child: const Text("Forgot Password?"),
                ),
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleLogin,
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
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
            if (_isForgotPassword) ...[
              if (!_otpSent) ...[
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
              ],
              if (_otpSent) ...[
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
                const SizedBox(height: 16),
                TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
              ],
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _otpSent
                          ? _verifyOtpAndResetPassword
                          : _requestOtpForReset,
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
                        _otpSent
                            ? "Reset Password"
                            : "Send OTP for Password Reset",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isForgotPassword = false;
                    _otpSent = false;
                    _otpController.clear();
                    _newPasswordController.clear();
                    _emailForReset = null;
                  });
                },
                child: const Text("Back to Login"),
              ),
            ],
            const SizedBox(height: 40),
            if (!_isForgotPassword) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    ),
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
