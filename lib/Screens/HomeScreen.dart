import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Service/auth_service.dart';
import 'NewTaskScreen.dart';
import 'TaskServicescloud.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthService>(context).user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Tasks"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Provider.of<AuthService>(context, listen: false).logout(),
          )
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("tasks")
            .where("userId", isEqualTo: uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (_, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          final docs = snap.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];

              return ListTile(
                title: Text(d["title"]),
                subtitle: Text("Status: ${d["status"]}"),
                trailing: d["status"] == "pending"
                    ? IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    TaskService.updateStatus(d.id, "completed");
                  },
                )
                    : Icon(Icons.check, color: Colors.blue),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewTaskScreen()),
        ),
      ),
    );
  }
}
