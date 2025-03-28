import 'package:cloud_firestore/cloud_firestore.dart';

class ListItem {
  final String id;
  final String name;

  ListItem({required this.id, required this.name});

  // Convert Firestore document to a ListItem object
  factory ListItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ListItem(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }

  // Convert a ListItem object to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
