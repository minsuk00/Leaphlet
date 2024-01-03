import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test/cloud_functions/test_firestore.dart';

class CreateNewEventPage extends StatefulWidget {
  const CreateNewEventPage({super.key});

  @override
  State<CreateNewEventPage> createState() => _CreateNewEventPageState();
}

class _CreateNewEventPageState extends State<CreateNewEventPage> {  
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  TextEditingController eventNameInput = TextEditingController();
 
  @override
  void initState() {
    startDateInput.text = "";
    endDateInput.text = "";
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Create New Event"),
      ),
      body: Container(
        padding: const EdgeInsets.all(250),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: eventNameInput,
              autofocus: false,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event Name',
              ),
            ),
            TextField(
              controller: startDateInput,
              //editing controller of this TextField
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "Start Date" //label text of field
              ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2100));
    
                if (pickedDate != null) {
                  if(kDebugMode){
                    print(pickedDate);
                  } //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                  if(kDebugMode){
                    print(formattedDate); 
                  } //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    startDateInput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
            ),
            TextField(
              controller: endDateInput,
              //editing controller of this TextField
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "End Date" //label text of field
              ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2100));
    
                if (pickedDate != null) {
                  if(kDebugMode){
                    print(pickedDate);
                  } //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  if(kDebugMode){
                    print(formattedDate); 
                  } //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    endDateInput.text = formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
            ),
            // code generation not completed
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Create Event Code'),
            ),
          ]
        )
      )
    );
  }
}