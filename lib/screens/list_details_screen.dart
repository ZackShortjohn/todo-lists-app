import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ListDetailsScreen extends StatelessWidget {
  final String listId;
  final FirestoreService _firestoreService = FirestoreService();

  ListDetailsScreen({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<List<String>>(
        stream: _firestoreService.getListItems(listId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final items = snapshot.data!;
          return items.isEmpty
              ? Center(
                  child: Text(
                    "No items yet. Add some!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          item,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _firestoreService.removeItem(listId, item),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newItem = await _showAddItemDialog(context);
          if (newItem != null && newItem.isNotEmpty) {
            _firestoreService.addItem(listId, newItem);
          }
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.teal,
        elevation: 6,
      ),
    );
  }

  Future<String?> _showAddItemDialog(BuildContext context) async {
    String newItem = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'New Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          onChanged: (value) => newItem = value,
          decoration: InputDecoration(hintText: "Enter item name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, newItem), child: Text('Add')),
        ],
      ),
    );
  }
}
