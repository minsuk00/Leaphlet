import 'package:flutter/material.dart';
import 'package:test/pages/exhibitor/home_exhibitor.dart';
import 'package:test/pages/organizer/home_organizer.dart';
import 'package:test/pages/visitor/home_visitor.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key, this.username = '', this.loginState = '', required this.googleLogin}) : super(key: key);
  final String username;
  final String loginState;
  final GoogleSignIn googleLogin;

  void _logout(BuildContext context) async {
    // Sign out the user
    await googleLogin.signOut();
    // Reset login state and navigate back to login page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LogInPage()));
  }

  void _showGuestRestrictionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Guest Mode Restriction'),
          content: const Text('You must log in to use this feature.'),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LogInPage()));
              },
              child: const Text('Return to log-in page'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: loginState == 'google_auth' ? Container() : const BackButton(),
        actions: _buildAppBarActions(context),
        title: Text(_buildAppBarTitle()),
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
                onPressed: () {
                  if (loginState == 'guest') {
                    _showGuestRestrictionDialog(context);
                  } else {
                    moveToPage(context, const ExhibitorHomePage());
                  }
                },
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
              onPressed: () {
                if (loginState == 'guest') {
                  _showGuestRestrictionDialog(context);
                } else {
                  moveToPage(context, const OrganizerHomePage());
                }
              },              
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
  List<Widget> _buildAppBarActions(BuildContext context) {
    if (loginState == 'google_auth') {
      return [
        TextButton(
          onPressed: () => _logout(context),
          child: Text(
            'LOGOUT',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 0.04 * MediaQuery.of(context).size.width,
              color: const Color(0xFF3E885E),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  String _buildAppBarTitle() {
    if (loginState == 'google_auth') {
      return 'Logged in as $username (Google)';
    } else if (loginState == 'guest') {
      return 'Logged in as a GUEST';
    } else {
      return '';
    }
  }
}
