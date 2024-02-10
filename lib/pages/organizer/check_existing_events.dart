import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:test/backend/local_functions/deprecated_event.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/pages/common/search_bar.dart';
import 'package:test/pages/visitor/event_view.dart';
import 'package:test/util/button_style.dart';
import 'package:test/util/navigate.dart';
import 'package:test/util/user_type.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test/cloud_functions/test_firestore.dart';

class CheckExistingEventsPage extends StatefulWidget {
  const CheckExistingEventsPage({super.key});

  @override
  State<CheckExistingEventsPage> createState() =>
      _CheckExistingEventsPageState();
}

class _CheckExistingEventsPageState extends State<CheckExistingEventsPage> {
  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.organizer, FileType.event).then((value) {
      setState(() {
        _eventData = value;
      });
    });
  }

  List _eventData = [];
  String _selectedEventCode = "";
  GlobalKey parentKey = GlobalKey(debugLabel: "parentKey");
  Map<String, GlobalKey> keyDict = {};
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();

  void setSelectedCode(String code) {
    setState(() {
      _selectedEventCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: const Text("Existing Events"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _eventData.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  CustomSearchBar(
                      widthRatio: 0.8,
                      dataList: _eventData,
                      parentKey: parentKey,
                      keyDict: keyDict,
                      setSelectedCode: setSelectedCode,
                      fileType: FileType.event,
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
                          itemCount: _eventData.length,
                          itemBuilder: (context, index) {
                            final eventInfo = _eventData[index];
                            final String eventName = eventInfo['eventName'];
                            final String eventCode = eventInfo['eventCode'];

                            keyDict[eventCode] = GlobalKey();
                            return Container(
                              key: keyDict[eventCode],
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 100),
                              child: ElevatedButton(
                                style: getButtonStyle(
                                    eventCode, _selectedEventCode),
                                onPressed: () => moveToPage(
                                  context,
                                  EventViewPage(eventInfo: eventInfo),
                                ),
                                child: ListTile(
                                  title: Text(eventName),
                                  subtitle: Text(eventCode),
                                  // tileColor: Colors.lightGreen,
                                  textColor: Colors.white,
                                  trailing: ElevatedButton(
                                    child: const Text("Copy Event Code"),
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: eventCode));
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
