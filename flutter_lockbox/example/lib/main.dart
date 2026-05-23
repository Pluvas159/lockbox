import 'package:flutter/material.dart';
import 'package:flutter_lockbox/flutter_lockbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _lockbox = FlutterLockbox();
  final _keyController = TextEditingController(text: 'my_secure_key');
  final _valueController = TextEditingController();
  
  String _statusMessage = 'Enter a key and value to test Lockbox.';

  Future<void> _save() async {
    final key = _keyController.text;
    final val = _valueController.text;
    if (key.isEmpty || val.isEmpty) {
      setState(() => _statusMessage = 'Key and Value cannot be empty.');
      return;
    }
    
    final success = await _lockbox.saveSecureString(key, val);
    setState(() {
      _statusMessage = success 
          ? 'Successfully encrypted & stored value under "$key"!' 
          : 'Failed to encrypt and store value.';
    });
  }

  Future<void> _read() async {
    final key = _keyController.text;
    if (key.isEmpty) {
      setState(() => _statusMessage = 'Key cannot be empty.');
      return;
    }
    
    final val = await _lockbox.getSecureString(key);
    setState(() {
      _statusMessage = val != null 
          ? 'Retrieved (decrypted): "$val"' 
          : 'No value found for key "$key".';
    });
  }

  Future<void> _delete() async {
    final key = _keyController.text;
    if (key.isEmpty) {
      setState(() => _statusMessage = 'Key cannot be empty.');
      return;
    }
    
    final success = await _lockbox.deleteSecureString(key);
    setState(() {
      _statusMessage = success 
          ? 'Successfully deleted key "$key".' 
          : 'Failed or nothing to delete.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lockbox SDK Example'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _keyController,
                decoration: const InputDecoration(
                  labelText: 'Key (Alias)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Value to Encrypt',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: _read,
                    child: const Text('Read'),
                  ),
                  ElevatedButton(
                    onPressed: _delete,
                    child: const Text('Delete'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
