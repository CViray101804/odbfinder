import 'package:flutter/material.dart';
import 'package:odbfinder/register/login.dart';
import 'package:odbfinder/screens/home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Track error states
  bool _emailHasError = false;
  bool _passwordHasError = false;
  bool _confirmPasswordHasError = false;
  
  // Custom warning message for confirm password (empty vs mismatch)
  String _confirmPasswordHint = 'Confirm your password';

  // Track visibility toggles for both password fields
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleSignup() {
    String emailText = _emailController.text.trim();
    String passwordText = _passwordController.text;
    String confirmPasswordText = _confirmPasswordController.text;

    setState(() {
      _emailHasError = emailText.isEmpty;
      _passwordHasError = passwordText.isEmpty;
      
      if (confirmPasswordText.isEmpty) {
        _confirmPasswordHasError = true;
        _confirmPasswordHint = 'Please confirm your password';
      } else if (passwordText != confirmPasswordText) {
        _confirmPasswordHasError = true;
        _confirmPasswordController.clear();
        _confirmPasswordHint = 'Passwords do not match';
      } else {
        _confirmPasswordHasError = false;
      }
    });

    // Check if any validation fails
    if (_emailHasError || _passwordHasError || _confirmPasswordHasError) {
      return;
    }

    // Extract display name from email address
    String userName = emailText.split('@').first;
    if (userName.isNotEmpty) {
      userName = userName[0].toUpperCase() + userName.substring(1);
    }

    // Navigate to Login Screen after successful signup validation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF004D7A), // Dark blue card wrapper
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE LOGO & TITLE (Centered) ---
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/odb_logo.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --- EMAIL FIELD ---
                  const Text(
                    'Email:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3D3D3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _emailHasError ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      onChanged: (value) {
                        if (_emailHasError && value.trim().isNotEmpty) {
                          setState(() => _emailHasError = false);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        hintText: _emailHasError
                            ? 'Please enter your email'
                            : 'Enter your email',
                        hintStyle: TextStyle(
                          color: _emailHasError
                              ? Colors.red.shade700
                              : Colors.black45,
                          fontSize: 14,
                          fontWeight: _emailHasError
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- PASSWORD FIELD ---
                  const Text(
                    'Password:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3D3D3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            _passwordHasError ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      onChanged: (value) {
                        if (_passwordHasError && value.isNotEmpty) {
                          setState(() => _passwordHasError = false);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        hintText: _passwordHasError
                            ? 'Please enter your password'
                            : 'Enter your password',
                        hintStyle: TextStyle(
                          color: _passwordHasError
                              ? Colors.red.shade700
                              : Colors.black45,
                          fontSize: 14,
                          fontWeight: _passwordHasError
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black54,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- CONFIRM PASSWORD FIELD ---
                  const Text(
                    'Confirm Password:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3D3D3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _confirmPasswordHasError
                            ? Colors.red
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      onChanged: (value) {
                        if (_confirmPasswordHasError && value.isNotEmpty) {
                          setState(() {
                            _confirmPasswordHasError = false;
                            _confirmPasswordHint = 'Confirm your password';
                          });
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        hintText: _confirmPasswordHint,
                        hintStyle: TextStyle(
                          color: _confirmPasswordHasError
                              ? Colors.red.shade700
                              : Colors.black45,
                          fontSize: 14,
                          fontWeight: _confirmPasswordHasError
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black54,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SIGNUP BUTTON ---
                  Center(
                    child: SizedBox(
                      width: 140,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C93BF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black54,
                              width: 1,
                            ),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- ALREADY HAVE AN ACCOUNT? LOGIN LINK ---
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}