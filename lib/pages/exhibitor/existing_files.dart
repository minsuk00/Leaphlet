import 'package:flutter/material.dart';

class ExistingFilesPage extends StatefulWidget {
  const ExistingFilesPage({super.key});

  @override
  State<ExistingFilesPage> createState() => _ExistingFilesPageState();
}

class _ExistingFilesPageState extends State<ExistingFilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Existing Files"),
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