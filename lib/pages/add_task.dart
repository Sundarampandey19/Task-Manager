import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _priority = 'Low';
  DateTime? _dueDate = DateTime.now();
  final bool _done = false;

  void _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dueDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final task = {
        'title': _title,
        'description': _description,
        'priority': _priority,
        'dueDate': _dueDate?.toIso8601String(),
        'done': _done
      };
      // print(task);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> tasks = prefs.getStringList('tasks') ?? [];

      tasks.add(jsonEncode(task));
       await prefs.setStringList('tasks', tasks);
      // print(
          // 'Task Added: Title: $_title, Description: $_description, Priority: $_priority, Due Date: $_dueDate, Done: $_done');
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Task Title"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onChanged: (value) {
                  _description = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Priority'),
                value: _priority,
                items: ['Low', 'Medium', 'High']
                    .map((priority) => DropdownMenuItem(
                        value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_dueDate == null
                      ? 'No Date Chosen!'
                      : 'Due Date: ${_dueDate!.toLocal()}'
                          .split(' ')[0]), // Display the chosen date
                  TextButton(
                    child: const Text('Choose Due Date'),
                    onPressed: () =>
                        _selectDueDate(context), // Show date picker
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add Task'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
