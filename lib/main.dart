import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: NotesPage(),
    );
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
      appBar: AppBar(title: Text("Safe Notes"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: "Enter your note",
                prefixIcon: Icon(Icons.note),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
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
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.lock, color: Colors.deepPurple),
                      title: Text(notes[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
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
      appBar: AppBar(title: Text("Enter PIN"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              savedPin == null ? "Create your PIN" : "Enter your PIN",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "PIN",
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
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
              child: Text(savedPin == null ? "Set PIN" : "Unlock"),
            ),
            Text(
              "Your notes are protected",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
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

    List<String> encodedNotes = notes
        .map((note) => base64Encode(utf8.encode(note)))
        .toList();

    await pref.setStringList('notes', encodedNotes);
  }

  Future<void> loadNotes() async {
    final pref = await SharedPreferences.getInstance();

    List<String> encodedNotes = pref.getStringList("notes") ?? [];

    setState(() {
      notes = encodedNotes
          .map((note) => utf8.decode(base64Decode(note)))
          .toList();
    });
  }
}
