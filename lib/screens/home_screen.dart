import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'list_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do Lists",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Map<String, dynamic>>>( 
          stream: _firestoreService.getLists(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final lists = snapshot.data!;
            if (lists.isEmpty) {
              return Center(
                child: Text(
                  "No to-do lists yet. Click the '+' to add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final list = lists[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    leading: Icon(Icons.folder_open, color: Colors.indigo, size: 30),
                    title: Text(
                      list['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever, color: Colors.redAccent),
                      onPressed: () => _showDeleteConfirmationDialog(context, list['id']),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDetailsScreen(listId: list['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newListName = await _showAddListDialog(context);
          if (newListName != null && newListName.isNotEmpty) {
            _firestoreService.addList(newListName);
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

  // Show the delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String listId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to delete this to-do list? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without doing anything
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.deleteList(listId); // Proceed with deletion
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showAddListDialog(BuildContext context) async {
    String newListName = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'New To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: TextField(
          onChanged: (value) => newListName = value,
          decoration: InputDecoration(
            hintText: "Enter list name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, newListName),
            child: Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
