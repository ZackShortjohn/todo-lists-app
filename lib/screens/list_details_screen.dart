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
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<String>>(
          stream: _firestoreService.getListItems(listId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            final items = snapshot.data!;
            if (items.isEmpty) {
              return Center(
                child: Text(
                  "No items in this list yet. Add some!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: Icon(Icons.arrow_right, color: Colors.grey[600]),
                    title: Text(
                      item,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _firestoreService.removeItem(listId, item),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newItem = await _showAddItemDialog(context);
          if (newItem != null && newItem.isNotEmpty) {
            _firestoreService.addItem(listId, newItem);
          }
        },
        child: Icon(Icons.add, size: 36, color: Colors.white),
        backgroundColor: Colors.indigo,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<String?> _showAddItemDialog(BuildContext context) async {
    String newItem = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'New Item',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: TextField(
          onChanged: (value) => newItem = value,
          decoration: InputDecoration(
            hintText: "Enter item name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, newItem),
            child: Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}