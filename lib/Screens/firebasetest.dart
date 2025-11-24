import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Test")),
      body: Center(
        child: ElevatedButton(
          child: Text("Test Firebase"),
          onPressed: () async {
            try {
              // Test Auth
              await FirebaseAuth.instance.signInAnonymously();

              // Test Firestore
              await FirebaseFirestore.instance
                  .collection("test")
                  .add({"time": DateTime.now().toString()});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Firebase connected successfully")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Firebase ERROR: $e")),
              );
            }
          },
        ),
      ),
    );
  }
}
