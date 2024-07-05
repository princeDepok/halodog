import 'package:flutter/material.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:frontend/screens/auth/sign_in.dart';
import 'package:frontend/screens/auth/sign_up.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
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
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
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
                      Text('Name: ${_userData?['name']}'),
                      Text('Email: ${_userData?['email']}'),
                    ],
                  ElevatedButton(
                    onPressed: () => _signOut(context),
                    child: Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}
