import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:to_do_list/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  String userName = "";
  bool _isLoading = true;  // Add a loading state variable

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUserName = prefs.getString('userName');

    // Simulate a delay for loading (you can remove this in production)
    await Future.delayed(Duration(seconds:2));

    if (savedUserName != null) {
      // If the username exists, navigate directly to TodoListScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => TodoListScreen(userName: savedUserName),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      // Stop loading and show login screen
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(223, 15, 77, 145),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                Colors.blue.shade600,
                Colors.blue.shade400,
                Colors.blue.shade200,
                Colors.blue.shade400,
                Colors.blue.shade600
              ])),
            ),
          ),
          // Show loading screen when _isLoading is true
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          // Otherwise, show the login screen form
          if (!_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                        labelText: 'Enter User Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String userName = _controller.text;
                      _saveUserName(userName);
                      if (userName.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => TodoListScreen(userName: userName),
                          ),
                        );
                      }
                    },
                    child: Text("Enter"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

