import 'package:flutter/material.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/common/info.dart';
import 'package:marquee/marquee.dart';

class SavedFilesPage extends StatefulWidget {
  const SavedFilesPage({super.key});

  @override
  State<SavedFilesPage> createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Marquee(
                  text: "Join the eco-friendly movement! 🌿 Let's cut down on paper waste together to protect our planet.",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                  velocity: 100.0,
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => moveToPage(context, const InfoPage()),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF766561)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                ),
                child: const Text("VIEW MORE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
