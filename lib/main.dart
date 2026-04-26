import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NotesPage());
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController noteController = TextEditingController();

  List<String> notes = [];

  bool isUnlocked = false;
  String correctPin = "1234";
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!isUnlocked) {
      return buildLockScreen();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Secure Notes")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter your note",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (noteController.text.isNotEmpty) {
                  setState(() {
                    notes.add(noteController.text);
                  });
                  noteController.clear();
                }
              },
              child: Text("Add Note"),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(notes[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            notes.removeAt(index);
                          });
                        },
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

  Widget buildLockScreen() {
    return Scaffold(
      appBar: AppBar(title: Text("Enter PIN")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter PIN",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (pinController.text == correctPin) {
                  setState(() {
                    isUnlocked = true;
                  });
                  pinController.clear();
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Wrong PIN")));
                }
              },
              child: Text("Unlock"),
            ),
          ],
        ),
      ),
    );
  }
}
