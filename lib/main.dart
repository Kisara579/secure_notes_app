import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? savedPin;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPin();
    loadNotes();
  }

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
              keyboardType: TextInputType.text,
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
                  saveNotes();
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
                          saveNotes();
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
                labelText: savedPin == null ? "Set a PIN" : "Enter PIN",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (savedPin == null) {
                  if (pinController.text.isNotEmpty) {
                    savePin(pinController.text);
                  }
                } else if (pinController.text == savedPin) {
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

  Future<void> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedPin = prefs.getString('pin');
    });
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);

    setState(() {
      savedPin = pin;
      isUnlocked = true;
    });

    pinController.clear();
  }

  Future<void> saveNotes() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList('notes', notes);
  }

  Future<void> loadNotes() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      notes = pref.getStringList("notes") ?? [];
    });
  }
}
