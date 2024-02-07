import 'package:flutter/material.dart';
import 'package:test/backend/local_functions/local_file_io.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/pages/common/search_anchor_widget.dart';
// import 'package:test/backend/local_functions/deprecated_event.dart';
// import 'package:test/backend/local_functions/util.dart';

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/services.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/visitor/event_view.dart';
import 'package:test/pages/visitor/register_new_event.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:test/util/user_type.dart';
import 'package:test/pages/common/info.dart';
import 'package:marquee/marquee.dart';

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
      setState(() {
        _eventData = value;
      });
    });
  }

  String _selectedEventCode = "";
  GlobalKey parentKey = GlobalKey(debugLabel: "parentKey");
  Map<String, GlobalKey> keyDict = {};
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();
  void modifyItemCode(String eventCode) {
    double anchorY = 0;
    double targetY = 0;

    // print("#############");
    // keyDict.forEach(
    //   (key, value) {
    //     BuildContext? ctx = value.currentContext;
    //     if (ctx == null) {
    //       print("$key : null");
    //     } else {
    //       RenderBox box = ctx.findRenderObject() as RenderBox;
    //       print("$key : ${box.localToGlobal(Offset.zero).dy}");
    //     }
    //   },
    // );
    // print("#############");

    // print("======$eventCode");
    if (eventCode != "") {
      RenderBox box = parentKey.currentContext?.findRenderObject() as RenderBox;
      anchorY = box.localToGlobal(Offset.zero).dy;

      BuildContext? ctx = keyDict[eventCode]?.currentContext;
      if (ctx == null) {
        //workaround. for some reason the bottom events has null for global key
        targetY = parentKey.currentContext!.size!.height + anchorY;
      } else {
        RenderBox tBox = ctx.findRenderObject() as RenderBox;
        targetY = tBox.localToGlobal(Offset.zero).dy;
      }
    }

    setState(() {
      _selectedEventCode = eventCode;
      // print("################ MODIFIED SELECTED EVENT CODE.");
      if (eventCode != "") {
        print(
            "############## Scrolling to y-position: ${targetY - anchorY} ($targetY - $anchorY)");
        scrollController.animateTo(
          targetY - anchorY,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }
    });
  }

  Padding getSearchBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final SearchAnchor searchAnchor = getSearchAnchor(context, _eventData,
        FileType.event, setState, modifyItemCode, searchController);
    // SearchController searchController = searchAnchor.searchController!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: 0.6 * screenWidth,
        child: searchAnchor,
      ),
    );
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
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.04),
          getSearchBar(context),

          // const Flexible(
          //   child: FractionallySizedBox(
          //     heightFactor: 0.08,
          //   ),
          // ),
          // const Spacer(flex: 1),
          SizedBox(height: screenHeight * 0.02),
          SizedBox(
            width: 0.4 * screenWidth,
            height: 0.08 * screenHeight,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF3E885E)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                ),
              ),
              onPressed: () {
                moveToPage(context, const RegisterNewEventPage()).then((_) {
                  // debugPrint('################## push popped!!');
                  loadEventListFromFile();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  "ADD EVENT",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: screenWidth * 0.04,
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
                    final String eventName = _eventData[index]['eventName'];
                    final String startDate = _eventData[index]['startDate'];
                    final String endDate = _eventData[index]['endDate'];
                    final String eventCode = _eventData[index]['eventCode'];
                    Color? getBgColor() {
                      if (_selectedEventCode == "") {
                        return Colors.white;
                      } else {
                        return eventCode == _selectedEventCode
                            ? Colors.grey[50]
                            : Colors.grey[300];
                      }
                    }

                    // print("$index $eventName : $eventCode");
                    keyDict[eventCode] = GlobalKey();
                    return Container(
                      key: keyDict[eventCode],
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 100),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: getBgColor(),
                        ),
                        // TODO: query event by event code
                        onPressed: () => moveToPage(
                            context,
                            EventViewPage(
                              eventName: eventName,
                              startDate: startDate,
                              endDate: endDate,
                              eventCode: eventCode,
                            )),
                        child: ListTile(
                          title: Text(
                            eventName,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
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
