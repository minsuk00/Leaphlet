import 'package:flutter/material.dart';
import 'package:leaphlet/backend/local_functions/local_file_io.dart';
import 'package:leaphlet/backend/local_functions/util.dart';
import 'package:leaphlet/pages/common/search_bar.dart';
import 'package:leaphlet/util/button_style.dart';
// import 'package:leaphlet/backend/local_functions/deprecated_event.dart';
// import 'package:leaphlet/backend/local_functions/util.dart';

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/services.dart';
import 'package:leaphlet/util/navigate.dart';
import 'package:leaphlet/pages/visitor/event_view.dart';
import 'package:leaphlet/pages/visitor/register_new_event.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:leaphlet/util/user_type.dart';
import 'package:leaphlet/pages/common/ad_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List _eventData = [];

  @override
  void initState() {
    super.initState();
    loadEventListFromFile();
    // resetLocalListFile(UserType.visitor,FileType.event);
  }

  void loadEventListFromFile() {
    getListFromLocalFile(UserType.visitor, FileType.event).then((value) {
      // debugPrint('############### INIT EVENTS PAGE ##################');
      // debugPrint('$value');
      if (mounted) {
        setState(() {
          _eventData = value;
        });
      }
    });
  }

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        scrolledUnderElevation: 0.0,
        leading: const BackButton(),
        title: const Text("Events"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        // child: _eventData.isEmpty
        // ? const SizedBox.shrink()
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.04),
            // getSearchBar(context),
            CustomSearchBar(
                widthRatio: 0.6,
                dataList: _eventData,
                parentKey: parentKey,
                keyDict: keyDict,
                setSelectedCode: setSelectedCode,
                fileType: FileType.event,
                scrollController: scrollController,
                searchController: searchController),

            // const Flexible(
            //   child: FractionallySizedBox(
            //     heightFactor: 0.08,
            //   ),
            // ),
            // const Spacer(flex: 1),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: 0.6 * screenWidth,
              height: 0.08 * screenHeight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                  ),
                  onPressed: () {
                    var registeredEventCodes = _eventData.map((e) => e['eventCode'] as String);
                    moveToPage(context, RegisterNewEventPage(registeredEventCodes: registeredEventCodes.toList())).then((_) {
                      // debugPrint('################## push popped!!');
                      loadEventListFromFile();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      "REGISTER NEW EVENT",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.06),

            Expanded(
              // flex: 100,
              child: Scrollbar(
                thickness: 15,
                key: parentKey,
                child: ListView.builder(
                    controller: scrollController,
                    // shrinkWrap: true,
                    itemCount: _eventData.length,
                    itemBuilder: (context, index) {
                      final eventInfo = _eventData[index];

                      // print("$index $eventName : $eventCode");
                      keyDict[eventInfo['eventCode']] = GlobalKey();
                      return Container(
                        key: keyDict[eventInfo['eventCode']],
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 100),
                        child: ElevatedButton(
                          style: getButtonStyle(eventInfo['eventCode'], _selectedEventCode),
                          onPressed: () => moveToPage(
                              context,
                              EventViewPage(
                                eventInfo: eventInfo,
                              )),
                          child: ListTile(
                            title: Text(
                              eventInfo['eventName'],
                              // textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                // shadows: <Shadow>[
                                //   Shadow(
                                //     offset: Offset(3.0, 3.0),
                                //     blurRadius: 3.0,
                                //     color: Color.fromARGB(255, 0, 0, 0),
                                //   ),
                                //   Shadow(
                                //     offset: Offset(3.0, 3.0),
                                //     blurRadius: 8.0,
                                //     color: Color.fromARGB(125, 0, 0, 255),
                                //   ),
                                // ],
                              ),
                            ),
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
