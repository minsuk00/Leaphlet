// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:leaphlet/backend/cloud_functions/test_firestore.dart';

class OrganizerHomePage extends StatefulWidget {
  const OrganizerHomePage({super.key});

  @override
  State<OrganizerHomePage> createState() => _OrganizerHomePageState();
}

class _OrganizerHomePageState extends State<OrganizerHomePage> {
  final TextEditingController _controller = TextEditingController();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(app: Firebase.app("test-project"));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List _msgList = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'message',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await _firestore
                      .collection("test_message")
                      .doc()
                      .set({"msg": _controller.text});
                },
                child: const Text("Send data")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                final msgs = await fsGetMsgs();
                setState(() {
                  _msgList = msgs;
                });
              },
              child: const Text("Get data"),
            ),
            SizedBox(
              height: 300,
              child: Scrollbar(
                thickness: 30,
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: _msgList.length,
                  itemBuilder: (context, index) {
                    return Card(child: Text(_msgList[index]['msg']));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}