import 'package:flutter/material.dart';

class SavedFilesPage extends StatefulWidget {
  const SavedFilesPage({super.key});

  @override
  State<SavedFilesPage> createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Saved Files"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
