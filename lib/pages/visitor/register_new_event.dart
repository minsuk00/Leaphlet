import 'package:flutter/material.dart';

class RegisterNewEventPage extends StatefulWidget {
  const RegisterNewEventPage({super.key});

  @override
  State<RegisterNewEventPage> createState() => _RegisterNewEventPageState();
}

class _RegisterNewEventPageState extends State<RegisterNewEventPage> {
  final TextEditingController _eventCodeInputController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Register New Event"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: TextFormField(
              controller: _eventCodeInputController,
              autofocus: false,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event Code',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an event code';
                }
                return null;
              },
            ),
          ),
          const ElevatedButton(
            onPressed: registerButtonPressed,
            child: Text('Register'),
          )
        ],
      ),
    );
  }
}

registerButtonPressed() {
  // TODO: implement event code check logic
}
