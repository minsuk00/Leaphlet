import 'package:cloud_firestore/cloud_firestore.dart';

fsGetMsgs() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestore.collection("test_message").get();
  return snapshot.docs.map((e) => e.data()).toList();
}
