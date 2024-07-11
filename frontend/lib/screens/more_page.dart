import 'package:flutter/material.dart';
import 'package:frontend/screens/core/home.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:frontend/screens/auth/sign_in.dart';
import 'package:frontend/screens/auth/sign_up.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isGuest = true;
  Map<String, String>? _userData;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    final TokenStorage tokenStorage = TokenStorage();
    bool isGuest = await tokenStorage.isGuest();
    if (!isGuest) {
      _userData = await tokenStorage.getUserData();
    }
    setState(() {
      _isGuest = isGuest;
    });
  }

  void _signOut(BuildContext context) async {
    final TokenStorage tokenStorage = TokenStorage();
    await tokenStorage.deleteTokens();
    await tokenStorage.deleteUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        color: Color(0xFFF5F5F5), // Background color similar to the picture
        child: Center(
          child: _isGuest
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text('Sign In'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20.0),
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Placeholder image
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Username: ${_userData?['username'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${_userData?['email'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _signOut(context),
                      child: Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
