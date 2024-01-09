import 'package:flutter/material.dart';
import 'package:test/util/navigate.dart';

class RegisterNewEventPage extends StatefulWidget {
  const RegisterNewEventPage({super.key});

  @override
  State<RegisterNewEventPage> createState() => _RegisterNewEventPageState();
}

class _RegisterNewEventPageState extends State<RegisterNewEventPage> {
  final TextEditingController _eventCodeInputController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Register New Event"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
            ElevatedButton(
              onPressed: () => registerButtonPressed(context),
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }

  registerButtonPressed(BuildContext context) {
    String eventCode = _eventCodeInputController.text;
    bool isEventCodeValid =
        eventCode == "logic"; //TODO: check if event code is valid
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            if (isEventCodeValid) {
              return AlertDialog(
                title: const Text("success"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        // popNTimes(context, 2);
                        popToPage(context, "EventsPage");
                      },
                      child: const Text("ok"))
                ],
              );
            } else {
              return AlertDialog(
                title: const Text("invalid event code"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("ok"))
                ],
              );
            }
          });
    }
  }
}
