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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getLists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final lists = snapshot.data!;
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    list['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _firestoreService.deleteList(list['id']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newListName = await _showAddListDialog(context);
          if (newListName != null && newListName.isNotEmpty) {
            _firestoreService.addList(newListName);
          }
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.teal,
        elevation: 6,
      ),
    );
  }

  Future<String?> _showAddListDialog(BuildContext context) async {
    String newListName = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'New List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          onChanged: (value) => newListName = value,
          decoration: InputDecoration(hintText: "Enter list name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, newListName), child: Text('Add')),
        ],
      ),
    );
  }
}
