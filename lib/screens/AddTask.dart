import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/screens/HomePage.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late TextEditingController namecontroller, bodycontroller, deadlinecontroller;
  List<String> priority = ["Low", "Medium", "High"];
  List<String> category = ["Daily", "Weekly", "Monthly"];

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController();
    bodycontroller = TextEditingController();
    deadlinecontroller = TextEditingController();
    getTask();
  }

  //List<dynamic> taskList = [];
  String taskList = "";
  String priorityValue = 'Low';
  String categoryValue = 'Daily';

  void getTask() async {
    var sharedPref = await SharedPreferences.getInstance();
    String tasks = sharedPref.getString("taskList") ?? "";
    taskList = tasks.isNotEmpty ? tasks.substring(0, tasks.length - 1) : tasks;
    print(taskList);
  }

  void addTask() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("taskList", taskList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Fields(
              fieldname: "Title",
              controller: namecontroller,
              multiLine: false,
            ),
            Fields(
              fieldname: "Body",
              controller: bodycontroller,
              multiLine: true,
            ),
            Fields(
              fieldname: "Deadline",
              controller: deadlinecontroller,
              multiLine: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DropdownButton(
                value: priorityValue,
                icon: const Icon(Icons.arrow_downward),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                elevation: 16,
                onChanged: (String? value) {
                  setState(() {
                    priorityValue = value!;
                  });
                },
                items: priority.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DropdownButton(
                value: categoryValue,
                icon: const Icon(Icons.arrow_downward),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                elevation: 16,
                onChanged: (String? value) {
                  setState(() {
                    categoryValue = value!;
                  });
                },
                items: category.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              onTap: () {
                if (kDebugMode) {
                  print(namecontroller.text);
                  print(bodycontroller.text);
                  print(deadlinecontroller.text);
                }
                Map<String, dynamic> taskMap = {
                  "name": namecontroller.text,
                  "body": bodycontroller.text,
                  "deadLine": deadlinecontroller.text,
                  "priority":priorityValue,
                  "category":categoryValue,
                };
                String task = jsonEncode(taskMap);
                taskList =
                    taskList.isNotEmpty ? "$taskList,$task]" : "[$task]";
                addTask();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()),
                  ModalRoute.withName('/'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class Fields extends StatelessWidget {
  const Fields({
    super.key,
    required this.fieldname,
    required this.controller,
    required this.multiLine,
  });
  final String fieldname;
  final TextEditingController controller;
  final bool multiLine;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: fieldname,
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        maxLines: multiLine ? null : 1,
      ),
    );
  }
}
