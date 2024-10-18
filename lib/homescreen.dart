import 'package:flutter/material.dart';
import 'package:rajitha/service.dart';
import 'package:intl/intl.dart';  // Import the intl package
import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await TaskService.loadTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        DateTime? selectedDate;

        return AlertDialog(
          backgroundColor: Colors.orange, // Orange background for the dialog
          title: const Text('Create Task', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white), // Picker icon
                    const SizedBox(width: 8),
                    Text('Select Date: ${selectedDate != null ? DateFormat.yMMMd().format(selectedDate!) : 'Not selected'}',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && selectedDate != null) {
                  Task newTask = Task(title: title, date: selectedDate!);
                  TaskService.addTask(newTask);
                  _loadTasks();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _editTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        String title = task.title;
        DateTime? selectedDate = task.date;

        return AlertDialog(
          backgroundColor: Colors.orange, // Orange background for the dialog
          title: const Text('Edit Task', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                controller: TextEditingController(text: title),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: task.date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white), // Picker icon
                    const SizedBox(width: 8),
                    Text('Select Date: ${selectedDate != null ? DateFormat.yMMMd().format(selectedDate!) : 'Not selected'}',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                TaskService.editTask(task, title, selectedDate!);
                _loadTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                TaskService.deleteTask(task);
                _loadTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange, // Orange background for AppBar
        title: const Center(
          child: Text(
            'TASKS',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // White text for title
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Space above the button
          Center(
            child: ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Orange background
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button
                ),
              ),
              child: const Text('Add Task', style: TextStyle(color: Colors.white)), // Centered "Add" button
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _editTask(tasks[index]),  // Edit task on grid item tap
                  child: Card(
                    color: Colors.orange,  // Change to a vivid orange color
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tasks[index].title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat.yMMMd().format(tasks[index].date),  // Format the date here
                            style: const TextStyle(color: Colors.black), // Black text for due date
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            onPressed: () => _deleteTask(tasks[index]),
                            icon: const Icon(Icons.delete),
                            color: Colors.white,  // White color for the delete icon
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
