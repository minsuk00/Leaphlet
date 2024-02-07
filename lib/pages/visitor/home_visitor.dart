import 'package:flutter/material.dart';
import 'package:test/pages/common/info.dart';
import 'package:test/pages/visitor/events.dart';
import 'package:test/pages/visitor/saved_files.dart';
import 'package:test/util/navigate.dart';
import 'package:marquee/marquee.dart';

class VisitorHomePage extends StatelessWidget {
  const VisitorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text('Home (Visitor)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.6 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const EventsPage()),                
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("Events",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.06 * screenWidth,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: screenWidth * 0.03),
            
            SizedBox(
              width: 0.6 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const SavedFilesPage()),                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("Saved Files",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.06 * screenWidth,
                    ),
                  ),
                ),
              ),
            ),
        
            SizedBox(height: screenWidth * 0.03),

            SizedBox(
              width: 0.6 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const InfoPage()),                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text("Info",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.06 * screenWidth,
                    ),
                  ),
                ),
              ),
            ),
          ],
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