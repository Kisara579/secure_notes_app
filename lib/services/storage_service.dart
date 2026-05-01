import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class StorageService {
  final storage = const FlutterSecureStorage();

  // pin
  Future<String?> loadPin() async {
    return await storage.read(key: 'pin');
  }

  Future<void> savePin(String pin) async {
    String hashed = hashPin(pin);
    await storage.write(key: 'pin', value: hashed);
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

  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> verifyPin(String inputPin) async {
    String? storedHash = await storage.read(key: 'pin');
    if (storedHash == null) return false;

    String inputHash = hashPin(inputPin);
    return inputHash == storedHash;
  }
}
