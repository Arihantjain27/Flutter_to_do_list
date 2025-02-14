import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:to_do_list/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}


class TodoListScreen extends StatefulWidget {
  final String userName;

  TodoListScreen({super.key, required this.userName});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Map<String, dynamic>> _todoItems =
      []; // List to hold tasks and their completion status
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

    Future<void> _loadTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedItems = prefs.getStringList('todoItems');

    if (savedItems != null) {
      setState(() {
        // Populate _todoItems with saved tasks
        _todoItems.clear();
        _todoItems.addAll(savedItems.map((task) {
          return {'task': task, 'isCompleted': false}; // Assuming all tasks are initially incomplete
        }));
      });
    }
  }

// Save the to-do items to SharedPreferences
    Future<void> _saveTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedItems = _todoItems.map((item) => item['task'] as String).toList(); // Convert to list of strings
    await prefs.setStringList('todoItems', savedItems); // Save the list to SharedPreferences
  }

  // Add a new task
  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add({'task': task, 'isCompleted': false});
      });
      _saveTodoItems();
      _controller.clear();
    }
  }

  // Remove a task
  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveTodoItems();
  }

  // Toggle task completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      _todoItems[index]['isCompleted'] = !_todoItems[index]['isCompleted'];
    });
    _saveTodoItems();
  }

  // Edit a task
  void _editTodoItem(int index, String newTask) {
    if (newTask.isNotEmpty) {
      setState(() {
        _todoItems[index]['task'] = newTask;
      });
      _saveTodoItems();
    }
  }

  // Show edit dialog
  void _showEditDialog(int index) {
    final TextEditingController editController = TextEditingController();
    editController.text = _todoItems[index]['task'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
                    labelText: 'Task',labelStyle: TextStyle(color: Colors.blue.shade900),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade900, width: 2.0), // When focused
    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",style: TextStyle(color: Colors.blue.shade900),),
            ),
            ElevatedButton(
              onPressed: () {
                _editTodoItem(index, editController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save",style: TextStyle(color: Colors.blue.shade900)),
            ),
          ],
        );
      },
    );
  }

  // Build a single task item
  Widget _buildTodoItem(Map<String, dynamic> taskData, int index) {
    bool isCompleted = taskData['isCompleted'] ?? false;

    return Card(
      elevation: 2.0,
      color: const Color.fromARGB(118, 0, 0, 0),
      child: ListTile(
        leading: Checkbox(

          checkColor: Colors.black,
        fillColor: WidgetStatePropertyAll(Colors.white),
          value: isCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              _toggleTaskCompletion(index);
            }
          },
        ),
        title: Text(
          taskData['task'],
          style: TextStyle(fontSize: 19,
            color: Colors.white,
            fontWeight: isCompleted ? FontWeight.normal : FontWeight.bold,
            decoration:
                isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(index),
            ),
            IconButton(
              icon: Icon(Icons.delete,
                  color: isCompleted
                      ? Colors.red
                      : const Color.fromARGB(255, 255, 255, 255)),
              onPressed: () => _removeTodoItem(index),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Colors.orange.shade600,Colors.orange.shade400,Colors.orange.shade200,Colors.blue.shade200,Colors.blue.shade400,Colors.blue.shade600])
    ),
      child: Scaffold(
        
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(
          //           context);
          //     },
          //     icon: Icon(
          //       Icons.arrow_back,
          //       color: Colors.white,
          //     )),
          title: Text(
            "To-Do List",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(223, 15, 77, 145),
        ),
        body: Container(
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [
      Colors.blue.shade600,
      Colors.blue.shade400,
        // Colors.blue.shade200,
      Colors.blue.shade200,
      Colors.blue.shade400,
      Colors.blue.shade600])
              // image: DecorationImage(
              //     image: AssetImage("assets/images/ToDoback.jpg"),
              //     fit: BoxFit.cover)
                  ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(50, 0, 0, 0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  // color: const Color.fromARGB(255, 158, 91, 91),
                  height: 200.0,
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "weclome, ${widget.userName}",
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 78),
                    child: ListView.builder(
                      itemCount: _todoItems.length,
                      itemBuilder: (context, index) {
                        return _buildTodoItem(_todoItems[index], index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            spacing: 18.0,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Add a task',labelStyle: TextStyle(color: Colors.blue.shade900),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade900, width: 2.0), // When focused
    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {_addTodoItem(_controller.text);
                FocusScope.of(context).unfocus();
                },
                child: Text("Add",style: TextStyle(color: Colors.blue.shade900),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


