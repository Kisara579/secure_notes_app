import 'package:flutter/material.dart';

class LockScreen extends StatelessWidget {
  final String? savedPin;
  final TextEditingController pinController;
  final Function(String) onSavePin;
  final Future<void> Function(String) onUnlock;

  const LockScreen({
    super.key,
    required this.savedPin,
    required this.pinController,
    required this.onSavePin,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Safe Notes"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20),
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
              onPressed: () {
                if (savedPin == null) {
                  if (pinController.text.isNotEmpty) {
                    onSavePin(pinController.text);
                  }
                } else {
                  onUnlock(pinController.text);
                }
              },
              child: Text(savedPin == null ? "Set PIN" : "Unlock"),
            ),

            SizedBox(height: 10),

            Text(
              "Your notes are protected",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
