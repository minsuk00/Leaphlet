import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:test/pages/exhibitor/confirmation.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test/cloud_functions/test_firestore.dart';

class UploadPamphletPage extends StatefulWidget {
  const UploadPamphletPage({super.key});

  @override
  State<UploadPamphletPage> createState() => _UploadPamphletPageState();
}

class _UploadPamphletPageState extends State<UploadPamphletPage> {
  TextEditingController eventCodeInput = TextEditingController();
  TextEditingController boothNumberInput = TextEditingController();
  TextEditingController orgNameInput = TextEditingController();
  TextEditingController yourNameInput = TextEditingController();
  TextEditingController emailAddressInput = TextEditingController();
  TextEditingController phoneNumberInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add a form key
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Upload Pamphlet"),
      ),
      body: Container(
        padding: const EdgeInsets.all(150),
        child: Form(
          key: _formKey, // Set the key to the form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: eventCodeInput,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Event Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: boothNumberInput,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Booth Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the booth number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: orgNameInput,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Organization Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the organization name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: yourNameInput,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailAddressInput,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email address';
                  }
                  return null;
                },
              ),
              TextField(
                controller: phoneNumberInput,
                autofocus: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),
              TextFormField(
                readOnly: true,
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    String filePath = result.files.single.path!;
                    // Do something with the file path (store it or display the file name, etc.)
                    if(kDebugMode){
                      print('Selected file: $filePath');
                    }
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Upload Pamphlet',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please upload the pamphlet';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    moveToPage(context, const ConfirmationPage());
                  }
                },
                child: const Text('Confirm'),
              ),
            ]
          )
        )
      )
    );
  }
}

void moveToPage(BuildContext context, StatefulWidget targetPage) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
}