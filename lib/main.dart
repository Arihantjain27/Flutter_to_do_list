import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
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
      color: Colors.grey,
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
                      : const Color.fromARGB(255, 0, 0, 0)),
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
        title: Text(
          "To-Do List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 58, 154, 183),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              // color: const Color.fromARGB(255, 158, 91, 91),
              height: 200.0,
              width: MediaQuery.sizeOf(context).width,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
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
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
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
            SizedBox(width: 8),
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
