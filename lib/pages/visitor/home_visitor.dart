import 'package:flutter/material.dart';
import 'package:test/pages/common/info.dart';
import 'package:test/pages/visitor/events.dart';
import 'package:test/pages/visitor/saved_files.dart';
import 'package:test/util/navigate.dart';

class VisitorHomePage extends StatelessWidget {
  const VisitorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Home (Visitor)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => moveToPage(context, const EventsPage()),
              child: const Text("Events"),
            ),
            OutlinedButton(
              onPressed: () => moveToPage(context, const SavedFilesPage()),
              child: const Text("Saved Files"),
            ),
            OutlinedButton(
              onPressed: () => moveToPage(context, const InfoPage()),
              child: const Text("Info"),
            ),
          ],
        ),
      ),
    );
  }
}
