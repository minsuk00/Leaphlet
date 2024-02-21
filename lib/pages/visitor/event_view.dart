import 'package:flutter/material.dart';
import 'package:leaphlet/backend/cloud_functions/pamphlets.dart';
import 'package:leaphlet/backend/local_functions/util.dart';
import 'package:leaphlet/pages/common/search_bar.dart';
import 'package:leaphlet/util/button_style.dart';
import 'package:leaphlet/util/navigate.dart';
import 'package:leaphlet/pages/visitor/file_information.dart';
import 'package:leaphlet/pages/common/ad_bar.dart';

class EventViewPage extends StatefulWidget {
  // const EventViewPage({super.key});
  final Map<String, dynamic> eventInfo;

  const EventViewPage({
    Key? key,
    required this.eventInfo,
  }) : super(key: key);
  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);

  List _pamphletData = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    getAllBoothInfoForAnEvent(widget.eventInfo['eventCode']).then((value) {
      // debugPrint('############### INIT EVENTS PAGE ##################');
      // debugPrint('$value');
      if (mounted) {
        setState(() {
          _pamphletData = value;
          _isLoaded = true;
        });
      }
    });
  }

  String _selectedBoothCode = "";
  GlobalKey parentKey = GlobalKey(debugLabel: "parentKey");
  Map<String, GlobalKey> keyDict = {};
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();
  void setSelectedCode(code) {
    setState(() {
      _selectedBoothCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        scrolledUnderElevation: 0.0,
        title: Text(widget.eventInfo['eventName']),
      ),
      body: !_isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Center(
              // child: _pamphletData.isEmpty
              // ? const SizedBox.shrink()
              child: Column(
                children: [
                  // getSearchBar(context),
                  CustomSearchBar(
                      widthRatio: 0.8,
                      dataList: _pamphletData,
                      parentKey: parentKey,
                      keyDict: keyDict,
                      setSelectedCode: setSelectedCode,
                      fileType: FileType.booth,
                      scrollController: scrollController,
                      searchController: searchController),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    // flex: 100,
                    child: Scrollbar(
                      key: parentKey,
                      thickness: 15,
                      child: ListView.builder(
                          controller: scrollController,
                          // shrinkWrap: true,
                          itemCount: _pamphletData.length,
                          itemBuilder: (context, index) {
                            // final String boothNumber =
                            //     _pamphletData[index]['boothNumber'];
                            // final String orgName = _pamphletData[index]['orgName'];

                            // final String yourName = _pamphletData[index]['yourName'];
                            // final String emailAddress =
                            //     _pamphletData[index]['emailAddress'];
                            // final String phoneNumber =
                            //     _pamphletData[index]['phoneNumber'];

                            final fileInfo = _pamphletData[index];
                            String boothCode = fileInfo['boothCode'];

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
                                // FileInformationPage(
                                //   orgName: orgName,
                                //   boothNumber: boothNumber,
                                //   yourName: yourName,
                                //   emailAddress: emailAddress,
                                //   phoneNumber: phoneNumber,
                                //   boothCode: boothCode,
                                // )),
                                child: ListTile(
                                  title: Text("${fileInfo['orgName']} (${fileInfo['boothNumber']})"),
                                  textColor: Colors.white,
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: AdBar(
        onUpdate: () {},
      ),
    );
  }
}
