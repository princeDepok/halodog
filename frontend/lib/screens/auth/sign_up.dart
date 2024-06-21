// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/sign_in.dart';
import 'package:frontend/utils/button.dart';
import 'package:frontend/utils/textfield.dart';
import 'package:frontend/services/api_services.dart'; // Import ApiService

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _termsAccepted = false;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  final ApiService _apiService = ApiService(); // Create instance of ApiService

  void _navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    if (!_termsAccepted) {
      _showErrorDialog('You must accept the terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final registrationData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone_number': _phoneNumberController.text,
      'address': _addressController.text,
      'province': _provinceController.text,
      'city': _cityController.text,
      'district': _districtController.text,
      'village': _villageController.text,
    };

    final success = await _apiService.registerAndLoginUser(registrationData);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } else {
      _showErrorDialog('Registration failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: const [
                      // Image.asset(
                      //   'assets/logo.png',
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
                CustomTextField(
                  icon: Icons.person,
                  controller: _usernameController,
                  hintText: 'Username',
                ),
                SizedBox(height: 16),
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
                CustomTextField(
                  icon: Icons.phone,
                  controller: _phoneNumberController,
                  hintText: 'Phone Number',
                ),
                SizedBox(height: 16),
                CustomTextField(
                  icon: Icons.home,
                  controller: _addressController,
                  hintText: 'Address',
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        icon: Icons.map,
                        controller: _provinceController,
                        hintText: 'Province',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        icon: Icons.location_city,
                        controller: _cityController,
                        hintText: 'City',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        icon: Icons.location_on,
                        controller: _districtController,
                        hintText: 'District',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        icon: Icons.location_city,
                        controller: _villageController,
                        hintText: 'Village',
                      ),
                    ),
                  ],
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
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(text: "Sign Up", onPressed: _register),
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
                    //   icon: Image.asset('assets/facebook.png'),
                    //   onPressed: () {
                    //     // Handle Facebook login
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Image.asset('assets/google.png'),
                    //   onPressed: () {
                    //     // Handle Google login
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Image.asset('assets/apple.png'),
                    //   onPressed: () {
                    //     // Handle Apple login
                    //   },
                    // ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: _navigateToSignIn,
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
