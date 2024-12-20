import 'package:flutter/material.dart';
import 'package:to_do_list/main.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(225, 27, 7, 49),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/ToDoback.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
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
                      )),
                ),
                ElevatedButton(
                    onPressed: () {
                      String userName = _controller.text;
                      if (userName.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  TodoListScreen(userName: userName),
                            ));
                      }
                    },
                    child: Text("Enter"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
