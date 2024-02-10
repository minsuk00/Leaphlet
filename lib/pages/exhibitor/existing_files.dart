import 'package:flutter/material.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/pages/common/search_bar.dart';
import 'package:test/pages/visitor/file_information.dart';
import 'package:test/util/button_style.dart';
import 'package:test/util/navigate.dart';
import 'package:test/util/user_type.dart';
import 'package:test/pages/common/ad_bar.dart';

class ExistingFilesPage extends StatefulWidget {
  const ExistingFilesPage({super.key});

  @override
  State<ExistingFilesPage> createState() => _ExistingFilesPageState();
}

class _ExistingFilesPageState extends State<ExistingFilesPage> {
  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.exhibitor, FileType.booth).then((value) {
      if (mounted) {
        setState(() {
          _boothData = value;
        });
      }
    });
  }

  List _boothData = [];
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
    // print(_boothData);

    final double screenHeight = MediaQuery.of(context).size.height;

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
        child: _boothData.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  CustomSearchBar(
                      widthRatio: 0.8,
                      dataList: _boothData,
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
                          itemCount: _boothData.length,
                          itemBuilder: (context, index) {
                            final fileInfo = _boothData[index];
                            String boothCode = fileInfo['boothCode'];
                            final String eventName = fileInfo['eventName'];
                            // final String orgName = _savedBoothList[index]['orgName'];

                            keyDict[boothCode] = GlobalKey();
                            return Container(
                              key: keyDict[boothCode],
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 100),
                              child: ElevatedButton(
                                style: getButtonStyle(
                                    boothCode, _selectedBoothCode),
                                onPressed: () => moveToPage(
                                  context,
                                  FileInformationPage(fileInfo: fileInfo),
                                ),
                                child: ListTile(
                                  title: Text(
                                      "${fileInfo['orgName']} (${fileInfo['boothNumber']})"),
                                  subtitle: Text("($eventName)"),
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
