import 'package:flutter/material.dart';
import 'package:leaphlet/pages/exhibitor/upload_pamphlet.dart';
import 'package:leaphlet/pages/exhibitor/existing_files.dart';
import 'package:leaphlet/pages/common/info.dart';
import 'package:leaphlet/util/navigate.dart';
import 'package:leaphlet/pages/common/ad_bar.dart';

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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
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
            ),

            SizedBox(height: screenWidth * 0.03),
            
            SizedBox(
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
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
            ),

            SizedBox(height: screenWidth * 0.03),

            SizedBox(
              width: 0.7 * screenWidth,
              height: 0.15 * screenHeight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdBar(
        onUpdate: () {
        },
      ), 
    );
  }
}
