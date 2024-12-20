import 'package:flutter/material.dart';
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

  // Add a new task
  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add({'task': task, 'isCompleted': false});
      });
      _controller.clear();
    }
  }

  // Remove a task
  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  // Toggle task completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      _todoItems[index]['isCompleted'] = !_todoItems[index]['isCompleted'];
    });
  }

  // Edit a task
  void _editTodoItem(int index, String newTask) {
    if (newTask.isNotEmpty) {
      setState(() {
        _todoItems[index]['task'] = newTask;
      });
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
              labelText: 'Task',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _editTodoItem(index, editController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
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
      elevation: 5.0,
      color: const Color.fromARGB(149, 149, 149, 149),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              _toggleTaskCompletion(index);
            }
          },
        ),
        title: Text(
          taskData['task'],
          style: TextStyle(
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginScreen(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "To-Do List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(225, 27, 7, 49),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/ToDoback.jpg"),
                fit: BoxFit.cover)),
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
                  padding: const EdgeInsets.only(top: 10),
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
                  labelText: 'Add a task',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _addTodoItem(_controller.text),
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
