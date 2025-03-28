import 'package:cloud_firestore/cloud_firestore.dart';

class TodoList {
  final String id;
  final String name;

  TodoList({required this.id, required this.name});

  // Convert Firestore document to a TodoList object
  factory TodoList.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TodoList(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }

  // Convert a TodoList object to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
