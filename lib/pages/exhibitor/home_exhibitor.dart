import 'package:flutter/material.dart';
import 'package:test/pages/exhibitor/upload_pamphlet.dart';
import 'package:test/pages/exhibitor/existing_files.dart';
import 'package:test/pages/common/info.dart';
import 'package:test/util/navigate.dart';


class ExhibitorHomePage extends StatefulWidget {
  const ExhibitorHomePage({super.key});

  @override
  State<ExhibitorHomePage> createState() => _ExhibitorHomePageState();
}

class _ExhibitorHomePageState extends State<ExhibitorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Home (Exhibitor)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => moveToPage(context, const UploadPamphletPage()),
              child: const Text("Upload Pamphlet"),
            ),
            OutlinedButton(
              onPressed: () => moveToPage(context, const ExistingFilesPage()),
              child: const Text("Check Existing Files"),
            ),
            OutlinedButton(
              onPressed: () => moveToPage(context, const InfoPage()),
              child: const Text("Information"),
            ),
          ],
        ),
      ),
    );
  }
}
