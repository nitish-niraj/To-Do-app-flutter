// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/screens/AddTask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  late List finalList;
  bool isEmpty = true;

  void addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTask(),
      ),
    );
  }

  void displayTask() async {
    var sharedPref = await SharedPreferences.getInstance();
    String taskList = sharedPref.getString("taskList") ?? "[]";
    print(taskList);
    setState(() {
      finalList = jsonDecode(taskList);
    });
    if (finalList.isNotEmpty) {
      isEmpty = false;
    }
    print("-----------");
    print(finalList);
  }

  @override
  void initState() {
    super.initState();
    displayTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("To-Do List"),
      ),
      body: isEmpty
          ? const Center(child: Text("No Tasks Added !", style: TextStyle(fontSize: 20),))
          : ListView.builder(
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> listItemMap = finalList[index];
                return ListTile(
                  title: Text(listItemMap['name']),
                  leading: Text((index + 1).toString()),
                  subtitle: Text(listItemMap['deadLine']),
                  trailing: Text(listItemMap['category']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
