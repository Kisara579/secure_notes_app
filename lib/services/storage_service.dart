import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  final storage = const FlutterSecureStorage();

  // pin
  Future<String?> loadPin() async {
    return await storage.read(key: 'pin');
  }

  Future<void> savePin(String pin) async {
    await storage.write(key: 'pin', value: pin);
  }

  // notes
  Future<List<String>> loadNotes() async {
    String? data = await storage.read(key: 'notes');

    if (data == null) return [];

    List<dynamic> decoded = jsonDecode(data);

    return decoded.cast<String>();
  }

  Future<void> saveNotes(List<String> notes) async {
    String encoded = jsonEncode(notes);
    await storage.write(key: 'notes', value: encoded);
  }
}
