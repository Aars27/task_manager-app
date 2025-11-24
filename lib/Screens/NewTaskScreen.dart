import 'package:flutter/material.dart';

import 'TaskServicescloud.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleC = TextEditingController();
  final descC = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleC, decoration: InputDecoration(labelText: "Task Title")),
            TextField(controller: descC, decoration: InputDecoration(labelText: "Description")),
            SizedBox(height: 20),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() => loading = true);
                await TaskService.createTask(titleC.text, descC.text);
                Navigator.pop(context);
              },
              child: Text("Create Task"),
            ),
          ],
        ),
      ),
    );
  }
}
