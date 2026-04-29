import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  // pin
  Future<String?> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin');
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
  }

  // notes
  Future<List<String>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedNotes = prefs.getStringList('notes') ?? [];

    return encodedNotes.map((note) => utf8.decode(base64Decode(note))).toList();
  }

  Future<void> saveNotes(List<String> notes) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> encodedNotes = notes
        .map((note) => base64Encode(utf8.encode(note)))
        .toList();

    await prefs.setStringList('notes', encodedNotes);
  }
}
