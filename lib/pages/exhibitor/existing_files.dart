import 'package:flutter/material.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';
import 'package:test/pages/common/ad_bar.dart';

class ExistingFilesPage extends StatefulWidget {
  const ExistingFilesPage({super.key});

  @override
  State<ExistingFilesPage> createState() => _ExistingFilesPageState();
}

class _ExistingFilesPageState extends State<ExistingFilesPage> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFC2D3CD),
  //     appBar: AppBar(
  //       backgroundColor: const Color(0xFFC2D3CD),
  //       leading: const BackButton(),
  //       title: const Text("Existing Files"),
  //     ),
  //     body: Center(
  //       child: ElevatedButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         child: const Text('Go back'),
  //       ),
  //     ),
  //   );
  // }
  List _boothData = [];

  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.exhibitor, FileType.booth).then((value) {
      setState(() {
        _boothData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_boothData);
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Existing Files"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scrollbar(
          thickness: 15,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _boothData.length,
            itemBuilder: (context, index) {
              final String eventName = _boothData[index]['eventName'];
              final String orgName = _boothData[index]['orgName'];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 100),
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10)),
                //   ),
                child: ListTile(
                  title: Text(orgName),
                  subtitle: Text(eventName),
                  tileColor: Colors.lightGreen,
                  // trailing: ElevatedButton(
                  //   child: const Text("Copy Event Code"),
                  //   onPressed: () {
                  //     // Clipboard.setData(ClipboardData(text: eventCode));
                  //   },
                  // ),
                ),
                // ),
              );
            }
          ),
        ),
      ),
      bottomNavigationBar: AdBar(
        onUpdate: () {
        },
      ),
    );
  }
}