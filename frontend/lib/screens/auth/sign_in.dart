// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/utils/button.dart';
import 'package:frontend/utils/textfield.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back button press
                },
              ),
            ),
            Spacer(),
            Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'PET DOC',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 40),
                CustomTextField(
                    icon: Icons.mail,
                    controller: _emailController,
                    hintText: "Email"),
                SizedBox(height: 20),
                CustomTextField(
                    icon: Icons.lock,
                    controller: _passwordController,
                    hintText: "Password"),
                SizedBox(height: 20),
                CustomButton(text: "Sign In", onPressed: () {}),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xFFFF8C02)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or continue with'),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     IconButton(
                //       icon: Image.asset('assets/facebook_icon.png'),
                //       iconSize: 50,
                //       onPressed: () {
                //         // Handle Facebook login
                //       },
                //     ),
                //     IconButton(
                //       icon: Image.asset('assets/google_icon.png'),
                //       iconSize: 50,
                //       onPressed: () {
                //         // Handle Google login
                //       },
                //     ),
                //     IconButton(
                //       icon: Image.asset('assets/apple_icon.png'),
                //       iconSize: 50,
                //       onPressed: () {
                //         // Handle Apple login
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
