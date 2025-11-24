import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskService {
  static const cloudRunUrl = "https://YOUR_CLOUD_RUN_URL/generateTaskId";

  static Future<void> createTask(String title, String desc) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 1. call Cloud Run
    final res = await http.post(
      Uri.parse(cloudRunUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": uid}),
    );

    if (res.statusCode != 200) throw Exception("API failed");

    final body = jsonDecode(res.body);
    final taskId = body["taskId"];

    // 2. write to Firestore
    await FirebaseFirestore.instance.collection("tasks").doc(taskId).set({
      "id": taskId,
      "userId": uid,
      "title": title,
      "description": desc,
      "status": "pending",
      "verified": false,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateStatus(String taskId, String status) async {
    await FirebaseFirestore.instance.collection("tasks").doc(taskId).update({
      "status": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
