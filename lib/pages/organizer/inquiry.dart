//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test/util/navigate.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:test/cloud_functions/test_firestore.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _messageInputController = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a form key

  // final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(app: Firebase.app("test-project"));
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _messageInputController.dispose();
    _emailInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Inquiry'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailInputController,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messageInputController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: submitInquiryButtonPressed,
                  child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }

  submitInquiryButtonPressed() {
    // TODO: send email to us
    // () async {
    //   await _firestore
    //       .collection("test_message")
    //       .doc()
    //       .set({"msg": _messageInputController.text});
    // };

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('success'),
            actions: [
              TextButton(
                onPressed: () {
                  popToPage(context, "OrganizerHomePage");
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
