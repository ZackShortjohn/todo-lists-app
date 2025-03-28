import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all lists
  Stream<List<Map<String, dynamic>>> getLists() {
    return _db.collection('Lists').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // Add a new list
  Future<void> addList(String name) async {
    await _db.collection('Lists').add({'name': name, 'items': []});
  }

  // Delete a list
  Future<void> deleteList(String listId) async {
    await _db.collection('Lists').doc(listId).delete();
  }

  // Fetch items from a list
  Stream<List<String>> getListItems(String listId) {
    return _db.collection('Lists').doc(listId).snapshots().map(
        (doc) => List<String>.from(doc.data()?['items'] ?? []));
  }

  // Add an item to a list
  Future<void> addItem(String listId, String item) async {
    await _db.collection('Lists').doc(listId).update({
      'items': FieldValue.arrayUnion([item])
    });
  }

  // Remove an item from a list
  Future<void> removeItem(String listId, String item) async {
    await _db.collection('Lists').doc(listId).update({
      'items': FieldValue.arrayRemove([item])
    });
  }
}
