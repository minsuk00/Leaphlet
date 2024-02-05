import 'package:flutter/material.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart';
import 'package:test/backend/local_functions/util.dart';
import 'package:test/pages/common/search_anchor_widget.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/visitor/file_information.dart';

class EventViewPage extends StatefulWidget {
  // const EventViewPage({super.key});
  const EventViewPage(
      {Key? key,
      required this.eventName,
      required this.startDate,
      required this.endDate,
      required this.eventCode})
      : super(key: key);
  final String eventName;
  final String startDate;
  final String endDate;
  final String eventCode;
  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);

  List? _pamphletData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    getAllBoothInfoForAnEvent(widget.eventCode).then((value) {
      // debugPrint('############### INIT EVENTS PAGE ##################');
      // debugPrint('$value');
      setState(() {
        _pamphletData = value;
      });
    });
  }

  String _selectedBoothCode = "";
  GlobalKey parentKey = GlobalKey(debugLabel: "parentKey");
  Map<String, GlobalKey> keyDict = {};
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();
  void modifyItemCode(String boothCode) {
    double anchorY = 0;
    double targetY = 0;

    if (boothCode != "") {
      RenderBox box = parentKey.currentContext?.findRenderObject() as RenderBox;
      anchorY = box.localToGlobal(Offset.zero).dy;

      BuildContext? ctx = keyDict[boothCode]?.currentContext;
      if (ctx == null) {
        //workaround. for some reason the bottom events has null for global key
        targetY = parentKey.currentContext!.size!.height + anchorY;
      } else {
        RenderBox tBox = ctx.findRenderObject() as RenderBox;
        targetY = tBox.localToGlobal(Offset.zero).dy;
      }
    }

    setState(() {
      _selectedBoothCode = boothCode;
      // print("################ MODIFIED SELECTED EVENT CODE.");
      if (boothCode != "") {
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
    final SearchAnchor searchAnchor = getSearchAnchor(context, _pamphletData!,
        FileType.booth, setState, modifyItemCode, searchController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: 0.8 * screenWidth,
        child: searchAnchor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        scrolledUnderElevation: 0.0,
        title: Text(widget.eventName),
      ),
      body: Center(
        child: _pamphletData == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  getSearchBar(context),
                  // Text(
                  //   "Start Date: ${widget.startDate}",
                  //   style: myTextStyle,
                  // ),
                  // Text(
                  //   "End Date: ${widget.endDate}",
                  //   style: myTextStyle,
                  // ),
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
                          itemCount: _pamphletData?.length,
                          itemBuilder: (context, index) {
                            // final String boothNumber =
                            //     _pamphletData[index]['boothNumber'];
                            // final String orgName = _pamphletData[index]['orgName'];

                            // final String yourName = _pamphletData[index]['yourName'];
                            // final String emailAddress =
                            //     _pamphletData[index]['emailAddress'];
                            // final String phoneNumber =
                            //     _pamphletData[index]['phoneNumber'];

                            final fileInfo = _pamphletData?[index];
                            String boothCode = fileInfo['boothCode'];
                            Color? getBgColor() {
                              if (_selectedBoothCode == "") {
                                return Colors.white;
                              } else {
                                return boothCode == _selectedBoothCode
                                    ? Colors.grey[50]
                                    : Colors.grey[300];
                              }
                            }

                            keyDict[boothCode] = GlobalKey();
                            return Container(
                              key: keyDict[boothCode],
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
                                  title: Text(
                                      "${fileInfo['orgName']} (${fileInfo['boothNumber']})"),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
