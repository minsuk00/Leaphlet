import 'package:flutter/material.dart';
import 'package:leaphlet/pages/common/search_bar.dart';
import 'package:leaphlet/pages/visitor/file_information.dart';
import 'package:leaphlet/pages/common/ad_bar.dart';
import 'package:leaphlet/backend/local_functions/local_file_io.dart';
import 'package:leaphlet/backend/local_functions/util.dart';
import 'package:leaphlet/util/button_style.dart';
import 'package:leaphlet/util/user_type.dart';
import 'package:leaphlet/util/navigate.dart';

class SavedFilesPage extends StatefulWidget {
  const SavedFilesPage({super.key});

  @override
  State<SavedFilesPage> createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.visitor, FileType.booth).then((value) {
      if (mounted) {
        setState(() {
          _savedBoothList = value;
        });
      }
    });
  }

  removeFromSaved(String boothCode) {
    setState(() {
      deleteItemFromLocalFile(boothCode, UserType.visitor, FileType.booth);
      _savedBoothList = _savedBoothList.where((element) => element['boothCode'] != boothCode).toList();
    });
  }

  ElevatedButton getStarWidget(String boothCode) {
    return ElevatedButton(
      onPressed: () => removeFromSaved(boothCode),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF04724D)),
        iconColor: MaterialStateProperty.all<Color>(Colors.yellow),
      ),
      child: const Icon(Icons.star),
    );
  }

  List _savedBoothList = [];
  String _selectedBoothCode = "";
  GlobalKey parentKey = GlobalKey(debugLabel: "parentKey");
  Map<String, GlobalKey> keyDict = {};
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();

  void setSelectedCode(String code) {
    setState(() {
      _selectedBoothCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_savedBoothList);
    // final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Saved Files"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _savedBoothList.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  CustomSearchBar(
                      widthRatio: 0.8,
                      dataList: _savedBoothList,
                      parentKey: parentKey,
                      keyDict: keyDict,
                      setSelectedCode: setSelectedCode,
                      fileType: FileType.booth,
                      scrollController: scrollController,
                      searchController: searchController),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: Scrollbar(
                      key: parentKey,
                      thickness: 15,
                      child: ListView.builder(
                          controller: scrollController,
                          // shrinkWrap: true,
                          itemCount: _savedBoothList.length,
                          itemBuilder: (context, index) {
                            final fileInfo = _savedBoothList[index];
                            String boothCode = fileInfo['boothCode'];
                            final String eventName = fileInfo['eventName'];
                            // final String orgName = _savedBoothList[index]['orgName'];

                            keyDict[boothCode] = GlobalKey();
                            return Container(
                              key: keyDict[boothCode],
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 100),
                              child: ElevatedButton(
                                style: getButtonStyle(boothCode, _selectedBoothCode),
                                onPressed: () => moveToPage(
                                  context,
                                  FileInformationPage(fileInfo: fileInfo),
                                ),
                                child: ListTile(
                                  title: Text("${fileInfo['orgName']} (${fileInfo['boothNumber']})"),
                                  subtitle: Text("($eventName)"),
                                  trailing: getStarWidget(fileInfo['boothCode']),
                                  textColor: Colors.white,
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: AdBar(
        onUpdate: () {},
      ),
    );
  }
}
// }
