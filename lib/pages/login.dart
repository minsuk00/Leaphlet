import 'package:flutter/material.dart';
import 'package:test/pages/start.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 0.5 * screenWidth,
                child: TextField(
                  controller: usernameController,
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.04 * screenWidth,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: screenWidth * 0.02),
              
              SizedBox(
                width: 0.5 * screenWidth,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 0.04 * screenWidth,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: screenWidth * 0.02),

              OutlinedButton(
                onPressed: () => logInButtonPressed(context, usernameController.text),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 0.01 * screenHeight, horizontal: 0.06 * screenWidth),
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Color(0xFF04724D)),
                  ),
                ),
                child: Text(
                  "Log-in",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 0.04 * screenWidth,
                  ),
                ),
              ),
              
              SizedBox(height: screenWidth * 0.02),
              
              TextButton(
                onPressed: () {
                      // Implement your sign-in with Google functionality here
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 0.01 * screenHeight, horizontal: 0.06 * screenWidth),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                ),
                child: Text(
                  "Sign-in with Google",
                  style: TextStyle(
                    fontSize: 0.04 * screenWidth,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void logInButtonPressed(BuildContext context, String username) {
  debugPrint("hi");
  Navigator.push(
      context, MaterialPageRoute(builder: (_) => StartPage(username)));
}
