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
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'username',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
              OutlinedButton(
                  onPressed: () =>
                      logInButtonPressed(context, usernameController.text),
                  child: const Text("log in")),
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
