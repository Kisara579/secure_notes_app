import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'screens/lock_screen.dart';
import 'screens/notes_page.dart';

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
      home: const HomeController(),
    );
  }
}

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  final storage = StorageService();

  TextEditingController noteController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  List<String> notes = [];
  bool isUnlocked = false;
  String? savedPin;

  @override
  void initState() {
    super.initState();
    loadPin();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    if (!isUnlocked) {
      return LockScreen(
        savedPin: savedPin,
        pinController: pinController,
        onSavePin: (pin) => savePin(pin),
        onUnlock: (inputPin) async {
          bool isValid = await storage.verifyPin(inputPin);

          if (isValid) {
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
      );
    }

    return NotesPage(
      noteController: noteController,
      notes: notes,
      onAddNote: () {
        if (noteController.text.isNotEmpty) {
          setState(() {
            notes.add(noteController.text);
          });
          saveNotes();
          noteController.clear();
        }
      },
      onDeleteNote: (index) {
        setState(() {
          notes.removeAt(index);
        });
        saveNotes();
      },
    );
  }

  Future<void> loadPin() async {
    final pin = await storage.loadPin();
    setState(() {
      savedPin = pin;
    });
  }

  Future<void> savePin(String pin) async {
    await storage.savePin(pin);

    final stored = await storage.loadPin();

    setState(() {
      savedPin = stored;
      isUnlocked = true;
    });

    pinController.clear();
  }

  Future<void> saveNotes() async {
    await storage.saveNotes(notes);
  }

  Future<void> loadNotes() async {
    final loadedNotes = await storage.loadNotes();

    setState(() {
      notes = loadedNotes;
    });
  }
}
