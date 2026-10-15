import 'package:flutter/material.dart';
import 'package:odbfinder/register/login.dart';

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

  // Dynamic hint message for confirm password field
  String _confirmPasswordHint = 'Confirm your password';

  // Visibility toggles
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

    if (_emailHasError || _passwordHasError || _confirmPasswordHasError) {
      return;
    }

    String userName = emailText.split('@').first;
    if (userName.isNotEmpty) {
      userName = userName[0].toUpperCase() + userName.substring(1);
    }

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
      // Modern soft background gradient matching login
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D7A), Color(0xFF0083B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- LOGO & TITLE (Centered) ---
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF004D7A).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/odb_logo.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Color(0xFF004D7A),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sign up to get started with ODB Finder',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- EMAIL FIELD ---
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      onChanged: (value) {
                        if (_emailHasError && value.trim().isNotEmpty) {
                          setState(() => _emailHasError = false);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: _emailHasError
                            ? 'Please enter your email'
                            : 'name@example.com',
                        hintStyle: TextStyle(
                          color: _emailHasError
                              ? Colors.red.shade400
                              : Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Color(0xFF004D7A), size: 20),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _emailHasError
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: _emailHasError ? 1.5 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF004D7A), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // --- PASSWORD FIELD ---
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      onChanged: (value) {
                        if (_passwordHasError && value.isNotEmpty) {
                          setState(() => _passwordHasError = false);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: _passwordHasError
                            ? 'Please enter your password'
                            : 'Create a password',
                        hintStyle: TextStyle(
                          color: _passwordHasError
                              ? Colors.red.shade400
                              : Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF004D7A), size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _passwordHasError
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: _passwordHasError ? 1.5 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF004D7A), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // --- CONFIRM PASSWORD FIELD ---
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
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
                        hintText: _confirmPasswordHint,
                        hintStyle: TextStyle(
                          color: _confirmPasswordHasError
                              ? Colors.red.shade400
                              : Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.lock_reset_outlined,
                            color: Color(0xFF004D7A), size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _confirmPasswordHasError
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: _confirmPasswordHasError ? 1.5 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF004D7A), width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- SIGNUP BUTTON (Full Width & Sleek) ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D7A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- LOGIN LINK ---
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: Color(0xFF004D7A),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}