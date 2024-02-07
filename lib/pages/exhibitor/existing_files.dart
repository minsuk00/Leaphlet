import 'package:flutter/material.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/common/info.dart';
import 'package:marquee/marquee.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Existing Files"),
      ),
      body: Scrollbar(
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Marquee(
                  text: "Join the eco-friendly movement! 🌿 Let's cut down on paper waste together to protect our planet.",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                  velocity: 100.0,
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => moveToPage(context, const InfoPage()),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF766561)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                ),
                child: const Text("VIEW MORE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}