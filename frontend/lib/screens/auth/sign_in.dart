// sign_in.dart

import 'package:flutter/material.dart';
import 'package:frontend/screens/core/home.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:frontend/screens/auth/sign_up.dart';
import 'package:frontend/utils/button.dart';
import 'package:frontend/utils/textfield.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    final apiService = ApiService();
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final loginData = {
        'username': email,
        'password': password,
      };

      final loginResponse = await apiService.loginUser(loginData);
      if (loginResponse.statusCode == 200) {
        final tokens = loginResponse.data;
        final tokenStorage = TokenStorage();
        await tokenStorage.saveTokens(tokens['access'], tokens['refresh']);

        // Fetch user details and store user data
        final userId = tokens['user_id'].toString();
        await tokenStorage.saveUserId(userId);
        final userDetailsResponse = await apiService.getUserDetails(int.parse(userId), tokens['access']);
        if (userDetailsResponse.statusCode == 200) {
          await tokenStorage.saveUserData(userDetailsResponse.data);
          _navigateToHome();
          print('Login and user data fetch successful');
        } else {
          print('Failed to fetch user details: ${userDetailsResponse.data}');
        }
      } else {
        print('Login failed: ${loginResponse.data}');
      }
    } else {
      print('Please fill in both fields');
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                CustomButton(text: "Sign In", onPressed: _signIn, ),
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
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                GestureDetector(
                  onTap: _navigateToSignUp,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
