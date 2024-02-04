import 'package:flutter/material.dart';
import 'package:test/pages/exhibitor/home_exhibitor.dart';
import 'package:test/pages/organizer/home_organizer.dart';
import 'package:test/pages/visitor/home_visitor.dart';
import 'package:test/util/navigate.dart';


class StartPage extends StatelessWidget {
  // const StartPage({super.key});
  const StartPage(this.username, {super.key});

  final String username;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        // leading: const Text(""),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Logged-in as $username',
                  // must add function to retreive username
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 0.04 * screenWidth,
                    color: const Color(0xFF3E885E),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Implement your logout functionality here
                  },
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.04 * screenWidth,
                      color: const Color(0xFF3E885E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFC2D3CD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.75 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const VisitorHomePage()),
                style: ButtonStyle(
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
                  child: Text("Use as Visitor",
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
              width: 0.75 * screenWidth,
              height: 0.15 * screenHeight,
              child: OutlinedButton(
                onPressed: () => moveToPage(context, const ExhibitorHomePage()),
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
                  child: Text("Use as Exhibitor",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.06 * screenWidth,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: screenWidth * 0.03),

            TextButton(
              onPressed: () => moveToPage(context, const OrganizerHomePage()),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(vertical: 0.01 * screenHeight, horizontal: 0.06 * screenWidth),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.035),
                  ),
                ),
              ),
              child: Text("Use as Organizer",
                style: TextStyle(
                  fontSize: 0.04 * screenWidth,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
