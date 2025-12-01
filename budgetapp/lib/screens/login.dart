import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscure = true;

  void _login() {
    Navigator.pushReplacementNamed(context, '/home'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/budget_bandits_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.35),
          ),

          SafeArea(
            child: Column(
              children: [
                // BLUE TOP BAR
                Container(
                  height: 56,
                  width: double.infinity,
                  color: const Color(0xFF0066FF),
                  alignment: Alignment.center,
                  child: const Text(
                    "Budget Bandits",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // FORM
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _userController,
                          label: "Username",
                          icon: Icons.person,
                          obscure: false,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _passController,
                          label: "Password",
                          icon: Icons.lock,
                          obscure: _obscure,
                          onToggleObscure: () {
                            setState(() => _obscure = !_obscure);
                          },
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "New User",
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Text field builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    VoidCallback? onToggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.5),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
