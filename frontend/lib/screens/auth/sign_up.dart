// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/button.dart';
import 'package:frontend/utils/textfield.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _termsAccepted = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40), // Add some space at the top
                Center(
                  child: Column(
                    children: const [
                      // Image.asset(
                      //   'assets/logo.png', // Replace with your logo asset path
                      //   height: 100,
                      // ),
                      Text(
                        'PET DOC',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        icon: Icons.person,
                        controller: _firstNameController,
                        hintText: 'First Name',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        icon: Icons.person,
                        controller: _lastNameController,
                        hintText: 'Last Name',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.email,
                  controller: _emailController,
                  hintText: 'Email',
                ),
                SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.lock,
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.lock,
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree with ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'terms and conditions',
                              style: TextStyle(color: Color(0xFFFF8C02)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle terms and conditions tap
                                },
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'privacy policy',
                              style: TextStyle(color: Color(0xFFFF8C02)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle privacy policy tap
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                CustomButton(text: "Sign Up", onPressed: () {}),
                SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or continue with'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    // IconButton(
                    //   icon: Image.asset(
                    //       'assets/facebook.png'), // Replace with your Facebook icon asset
                    //   onPressed: () {
                    //     // Handle Facebook login
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Image.asset(
                    //       'assets/google.png'), // Replace with your Google icon asset
                    //   onPressed: () {
                    //     // Handle Google login
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Image.asset(
                    //       'assets/apple.png'), // Replace with your Apple icon asset
                    //   onPressed: () {
                    //     // Handle Apple login
                    //   },
                    // ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Handle sign in
                    },
                    child: Text(
                      'Already have an account? Sign in',
                      style: TextStyle(color: Color(0xFFFF8C02)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
