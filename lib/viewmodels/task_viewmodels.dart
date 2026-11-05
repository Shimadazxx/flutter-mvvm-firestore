import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart'; // Import file model

class TaskViewModel extends ChangeNotifier {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> get tasksStream {
    return tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    });
  }

  Future<void> addTask(String title, String detail) async {
    try {
      await tasksCollection.add({
        'title': title,
        'detail': detail,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error adding task: $e");
    }
  }

  Future<void> updateTask(String id, String title, String detail) async {
    try {
      await tasksCollection.doc(id).update({
        'title': title,
        'detail': detail,
      });
    } catch (e) {
      debugPrint("Error updating task: $e");
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await tasksCollection.doc(id).delete();
    } catch (e) {
      debugPrint("Error deleting task: $e");
    }
  }
}