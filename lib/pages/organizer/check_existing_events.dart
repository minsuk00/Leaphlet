import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test/cloud_functions/test_firestore.dart';

class CheckExistingEventsPage extends StatefulWidget {
  const CheckExistingEventsPage({super.key});

  @override
  State<CheckExistingEventsPage> createState() => _CheckExistingEventsPageState();
}

class _CheckExistingEventsPageState extends State<CheckExistingEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Existing Events"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back'),
        ),
      ),
    );
  }
}