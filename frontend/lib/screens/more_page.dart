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
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_userData != null)
                    ...[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Ganti dengan path gambar profil Anda
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Username: ${_userData?['username']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Email: ${_userData?['email']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signOut(context),
                    child: Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
