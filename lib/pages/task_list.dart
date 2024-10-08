import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    setState(() {
      // Map each task string (JSON) to a Map<String, dynamic>
      _tasks = taskList.map((task) {
        return jsonDecode(task) as Map<String, dynamic>;
      }).toList();
    });
  }

  void _deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    // Remove the task at the given index
    taskList.removeAt(index);

    // Save the updated task list
    await prefs.setStringList('tasks', taskList);

    // Reload the tasks
    _loadTasks();
  }

  void _markTaskAsDone(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    // Mark the task as done
    Map<String, dynamic> task = jsonDecode(taskList[index]);
    task['done'] = true;

    // Replace the task with the updated task
    taskList[index] = jsonEncode(task);

    // Save the updated task list
    await prefs.setStringList('tasks', taskList);

    // Reload the tasks
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> tasks = ['task1', 'task2', 'task3'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks available'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(
                      task['title'],
                      style: TextStyle(
                      decoration: task['done']
                      ? TextDecoration.lineThrough // Strikethrough if the task is done
                      : TextDecoration.none, // No decoration if not done
                      ),
                    ),                  
                  subtitle: Text(task['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: task['done']
                            ? null // Disable if already marked as done
                            : () => _markTaskAsDone(index),
                        icon: const Icon(Icons.check),
                        color: task['done'] ? Colors.green : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () => _deleteTask(index),
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/add_task');
            if (result == true) {
              _loadTasks();
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
