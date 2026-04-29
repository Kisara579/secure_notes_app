import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  final TextEditingController noteController;
  final List<String> notes;
  final VoidCallback onAddNote;
  final Function(int) onDeleteNote;

  const NotesPage({
    super.key,
    required this.noteController,
    required this.notes,
    required this.onAddNote,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safe Notes"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "Enter your note",
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: onAddNote,
              child: Text("Add Note"),
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.lock, color: Colors.deepPurple),
                      title: Text(notes[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDeleteNote(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}