import 'package:flutter/material.dart';
import 'package:test/pages/visitor/file_information.dart';
import 'package:test/pages/common/ad_bar.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/util/user_type.dart';
import 'package:test/util/navigate.dart';

class SavedFilesPage extends StatefulWidget {
  const SavedFilesPage({super.key});

  @override
  State<SavedFilesPage> createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFC2D3CD),
  //     appBar: AppBar(
  //       backgroundColor: const Color(0xFFC2D3CD),
  //       leading: const BackButton(),
  //       title: const Text("Saved Files"),
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

  List _savedBoothList = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.visitor, FileType.booth).then((value) {
      setState(() {
        _savedBoothList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_savedBoothList);
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Existing Files"),
      ),
      body: Scrollbar(
        // key: parentKey,
        thickness: 15,
        child: ListView.builder(
            controller: scrollController,
            // shrinkWrap: true,
            itemCount: _savedBoothList.length,
            itemBuilder: (context, index) {
              final fileInfo = _savedBoothList[index];
              // String? boothCode = fileInfo['boothCode'];
              final String eventName = _savedBoothList[index]['eventName'];
              final String orgName = _savedBoothList[index]['orgName'];

              // keyDict[boothCode] = GlobalKey();
              return Container(
                // key: keyDict[boothCode],
                margin:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    // backgroundColor: getBgColor(),
                  ),
                  // TODO: query event by event code
                  onPressed: () => moveToPage(
                    context,
                    FileInformationPage(fileInfo: fileInfo),
                  ),
                  child: ListTile(
                    title: Text(
                        "${fileInfo['orgName']} (${fileInfo['boothNumber']})"),
                    subtitle: Text(eventName),
                  ),
                ),
              );
            }),
      ),
      bottomNavigationBar: AdBar(
        onUpdate: () {
        },
      ),
    );
  }
}
// }
