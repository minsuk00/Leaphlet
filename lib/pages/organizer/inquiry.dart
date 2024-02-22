// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leaphlet/backend/cloud_functions/inquiry.dart';
import 'package:leaphlet/util/navigate.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:leaphlet/cloud_functions/test_firestore.dart';

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
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.15;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text('Inquiry'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(paddingValue),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth * 0.01),
                
                TextFormField(
                  controller: _emailInputController,
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    labelText: 'Your Email',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: screenWidth * 0.02),
                
                TextFormField(
                  controller: _messageInputController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    labelText: 'Message',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: screenWidth * 0.04),
                
                SizedBox(
                  width: 0.3 * screenWidth,
                  height: 0.05 * screenHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: submitInquiryButtonPressed,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Color(0xFF04724D)),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 0.04 * screenWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

  void submitInquiryButtonPressed() async {
    // () async {
    //   await _firestore
    //       .collection("test_message")
    //       .doc()
    //       .set({"msg": _messageInputController.text});
    // };
    if (_formKey.currentState!.validate()) {
      // Firestoreにデータを保存
      // await _firestore.collection("inquiry").add({
      //   'email': _emailInputController.text,
      //   'message': _messageInputController.text,
      // });
      try {
        await sendInquiry(
            _emailInputController.text, _messageInputController.text);
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('success'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // popToPage(context, "OrganizerHomePage");
                      popNTimes(context, 2);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        throw Exception("############### inquiry error: $e");
      }
    }
  }
}
