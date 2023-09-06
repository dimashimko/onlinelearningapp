// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This controller is connected to the text field
  late TextEditingController _controller;

  // Whether the textfield is read-only or not
  bool _isReadonly = false;

  // Whether the text field is disabled or enabled
  bool _isDisabled = false;

  @override
  void initState() {
    _controller = TextEditingController(text: 'Default Text');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          children: [
            TextField(
              readOnly: _isReadonly,
              enabled: !_isDisabled,
              // _isDisabled = false -> enbalbe = true
              // _isDisabled = true -> enable = false

              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Label',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SwitchListTile(
              value: _isReadonly,
              onChanged: (value) {
                setState(() {
                  _isReadonly = value;
                });
              },
              title: const Text('TextField is read-only'),
            ),
            SwitchListTile(
              value: _isDisabled,
              onChanged: (value) {
                setState(() {
                  _isDisabled = value;
                });
              },
              title: const Text('TextField is disabled'),
            ),
          ],
        ),
      ),
    );
  }
}