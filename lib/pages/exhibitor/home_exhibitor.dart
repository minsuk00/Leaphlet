import 'package:flutter/material.dart';
import 'package:test/pages/exhibitor/upload_pamphlet.dart';
import 'package:test/pages/exhibitor/existing_files.dart';
import 'package:test/pages/common/info.dart';
import 'package:test/util/navigate.dart';
import 'package:marquee/marquee.dart';


class ExhibitorHomePage extends StatefulWidget {
  const ExhibitorHomePage({super.key});

  @override
  State<ExhibitorHomePage> createState() => _ExhibitorHomePageState();
}

class _ExhibitorHomePageState extends State<ExhibitorHomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text('Home (Exhibitor)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const UploadPamphletPage()),                
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
                  child: Text("Upload Pamphlet",
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
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const ExistingFilesPage()),                style: ButtonStyle(
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
                  child: Text("Existing Files",
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
              width: 0.7 * screenWidth,
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
