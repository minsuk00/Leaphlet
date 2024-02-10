import 'package:flutter/material.dart';
import 'package:test/pages/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  String loginState = '';
  // String _displayName = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(FocusNode());
      }
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFC2D3CD),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [              
              OutlinedButton(
                onPressed: () async {
                  // setState(() {
                  //   loginState = 'google_auth'; // Set login state to 'google_auth'
                  // });
                  // logInButtonPressed(context, usernameController.text, loginState);
                  // Google authentication
                  GoogleSignInAccount? signinAccount = await googleLogin.signIn();
                  if (signinAccount == null) return;
                  GoogleSignInAuthentication auth =
                      await signinAccount.authentication;
                  final OAuthCredential credential = GoogleAuthProvider.credential(
                    idToken: auth.idToken,
                    accessToken: auth.accessToken,
                  );
                  // register login information to firebase
                  User? user =
                      (await FirebaseAuth.instance.signInWithCredential(credential))
                          .user;
                  if (user != null) {
                    setState(() {
                      loginState = 'google_auth';
                      // _displayName = user.displayName!;
                    });
                    if (mounted) {
                      logInButtonPressed(context, usernameController.text, loginState, googleLogin);
                    }
                  }                  
                },
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
                  "Log in with Google",
                  style: TextStyle(
                    fontSize: 0.04 * screenWidth,
                    fontFamily: 'Roboto',
                    //fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.02),

              OutlinedButton(
                onPressed: () {
                  setState(() {
                    loginState = 'guest'; // Set login state to 'guest'
                  });
                  logInButtonPressed(context, usernameController.text, loginState, googleLogin);
                },
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
                  "Log in as a GUEST",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 0.04 * screenWidth,
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.02),

              Image.asset(
                'assets/logo1.png',
                width: 500, 
                height: 500,
              ),

              SizedBox(height: screenWidth * 0.02),

              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    loginState = 'google_auth';
                  });
                  logInButtonPressed(context, usernameController.text, loginState, googleLogin);
                },
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
                  "Log in as God",
                  style: TextStyle(
                    fontSize: 0.04 * screenWidth,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

void logInButtonPressed(BuildContext context, String username, String loginState, googleLogin) {
  debugPrint("hi");
  Navigator.push(
      context, MaterialPageRoute(builder: (_) => StartPage(username: username, loginState: loginState, googleLogin: googleLogin)));
}

// SizedBox(
//   width: 0.5 * screenWidth,
//   child: TextField(
//     controller: usernameController,
//     autofocus: false,
//     textInputAction: TextInputAction.next,
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//       ),
//       labelText: 'Username',
//       filled: true,
//       fillColor: Colors.white,
//       labelStyle: TextStyle(
//         fontFamily: 'Roboto',
//         fontSize: 0.04 * screenWidth,
//       ),
//     ),
//   ),
// ),

// SizedBox(height: screenWidth * 0.02),

// SizedBox(
//   width: 0.5 * screenWidth,
//   child: TextField(
//     controller: passwordController,
//     obscureText: true,
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//       ),
//       labelText: 'Password',
//       filled: true,
//       fillColor: Colors.white,
//       labelStyle: TextStyle(
//         fontFamily: 'Roboto',
//         fontSize: 0.04 * screenWidth,
//       ),
//     ),
//   ),
// ),

// SizedBox(height: screenWidth * 0.02),

// OutlinedButton(
//   //onPressed: () => logInButtonPressed(context, usernameController.text),
//   onPressed: () {
//     // do nothing
//   },
//   style: ButtonStyle(
//     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
//     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//       RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//       ),
//     ),
//     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//       EdgeInsets.symmetric(vertical: 0.01 * screenHeight, horizontal: 0.06 * screenWidth),
//     ),
//     side: MaterialStateProperty.all<BorderSide>(
//       const BorderSide(color: Color(0xFF04724D)),
//     ),
//   ),
//   child: Text(
//     "Log-in",
//     style: TextStyle(
//       fontFamily: 'Roboto',
//       fontSize: 0.04 * screenWidth,
//       decoration: TextDecoration.lineThrough,
//     ),
//   ),
// ),