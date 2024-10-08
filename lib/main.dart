import 'package:flutter/material.dart';
import 'package:todo_app/pages/add_task.dart';
import 'package:todo_app/pages/task_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      routes: {
        '/add_task':  (context)=> const  AddTodo(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskList(),
    );
  }
}
  