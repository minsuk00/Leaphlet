import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


// TODO: Do we need to store inquiry in database? or do we need to just send it?
Future sendInquiry(String email, String message) async {
  debugPrint('##### send inquiry method');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Firestoreにデータを保存
  return await firestore.collection("inquiry").add({
    'email': email,
    'message': message,
  }); 
}
