import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:test/pages/exhibitor/confirmation.dart';
import 'package:test/util/navigate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/cloud_functions/event.dart';

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
  TextEditingController pamphletInput = TextEditingController();
  late String pamphletID;
  late String _selectedFilePath;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a form key
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    pamphletID = generatePamphletID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.15;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Upload Pamphlet"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(paddingValue),
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
                    labelText: 'Event Code',
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
                  controller: pamphletInput,
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      String filePath = result.files.single.path!;
                      _selectedFilePath = filePath;
                      // Do something with the file path (store it or display the file name, etc.)
                      // String fileName =
                      //   filePath.substring(filePath.lastIndexOf("/")+1);
                      // pamphletInput.text = fileName;
                      pamphletInput.text = filePath.substring(filePath.lastIndexOf("/")+1);
                      if (kDebugMode) {
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await uploadPamphlet();
                      if (mounted) {
                        moveToPage(context, const ConfirmationPage());
                      }
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ]
            )
          )
        )
      )
    );
  }

  Future<void> uploadPamphlet() async {
    if (_selectedFilePath.isNotEmpty) {
      File file = File(_selectedFilePath);

      String fileName = pamphletInput.text; // またはユニークなファイル名を生成

      try {
        // upload pdf to Firebase Storage
        TaskSnapshot snapshot = await _storage.ref('uploaded_pdfs/$fileName').putFile(file);

        // get URL
        String fileUrl = await snapshot.ref.getDownloadURL();
        var eventDetails = await getEventInfo(eventCodeInput.text); 
        bool isEventCodeValid =
          eventDetails != null;
        if (isEventCodeValid) {
          String? eventName = eventDetails['eventName'];
          // save pamphlet information to Firestore
          await _firestore.collection("uploaded_pamphlets").add({
            'eventCode': eventCodeInput.text,
            'eventName': eventName,
            'boothNumber': boothNumberInput.text,
            'orgName': orgNameInput.text,
            'yourName': yourNameInput.text,
            'emailAddress': emailAddressInput.text,
            'phoneNumber': phoneNumberInput.text,
            'boothCode': pamphletID,
            'pamphletURL': fileUrl,
          });
        }
          print('File Uploaded');
      } catch (e) {
        print('Error unploaded: $e');
      }
    }
  }

  String generatePamphletID() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random rnd = Random();
    String code = '';
    for (int i = 0; i < 7; i++) {
      code += chars[rnd.nextInt(chars.length)];
    }
    return code;
  }
}