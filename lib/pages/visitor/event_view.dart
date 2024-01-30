import 'package:flutter/material.dart';
import 'package:test/backend/cloud_functions/pamphlets.dart';
import 'package:test/util/navigate.dart';
import 'package:test/pages/visitor/file_information.dart';

class EventViewPage extends StatefulWidget {
  // const EventViewPage({super.key});
  const EventViewPage({Key? key, required this.eventName, required this.startDate, required this.endDate, required this.eventCode}) : super(key: key);
  final String eventName;
  final String startDate;
  final String endDate;
  final String eventCode;
  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  final TextStyle myTextStyle = const TextStyle(fontSize: 25);

  List _pamphletData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _pamphletData = await getAllBoothInfoForAnEvent(widget.eventCode);
    setState(() {});
  }

  Padding getSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        child: SearchAnchor(
          isFullScreen: false,
          // viewLeading: const Icon(null),
          viewLeading: IconButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
              hintText: 'SEARCH',
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(_pamphletData.length, (index) {
              final String orgName = _pamphletData[index]['orgName'];
              return ListTile(
                  title: Text(orgName),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      controller.closeView(orgName);
                    });
                  });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFC2D3CD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2D3CD),
        leading: const BackButton(),
        title: Text(widget.eventName),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: screenWidth * 0.02),
            Text(
              "Start Date: ${widget.startDate}",
              style: myTextStyle,
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              "End Date: ${widget.endDate}",
              style: myTextStyle,
            ),
            SizedBox(height: screenWidth * 0.02),
            // getAllBoothInfoForAnEvent(widget.eventCode)
            getSearchBar(context),
            SizedBox(height: screenWidth * 0.05),
            Expanded(
              // flex: 100,
              child: Scrollbar(
                thickness: 15,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pamphletData.length,
                  itemBuilder: (context, index) {
                    final String boothNumber = _pamphletData[index]['boothNumber'];
                    final String orgName = _pamphletData[index]['orgName'];

                    final String yourName = _pamphletData[index]['yourName'];
                    final String emailAddress = _pamphletData[index]['emailAddress'];
                    final String phoneNumber = _pamphletData[index]['phoneNumber'];

                    final String boothCode = _pamphletData[index]['boothCode'];

                    // Define colors to alternate
                    Color color;
                    if (index % 2 == 0) {
                      color = const Color(0xFF04724D); // First color
                    } else {
                      color = const Color(0xFF3E885E); // Second color
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: color,
                        ),
                        // TODO: query event by event code
                        onPressed: () => moveToPage(context, FileInformationPage(
                            orgName: orgName,
                            boothNumber: boothNumber,
                            yourName: yourName, 
                            emailAddress: emailAddress, 
                            phoneNumber: phoneNumber, 
                            boothCode: boothCode,
                        )),
                        child: ListTile(
                          title: Text("$boothNumber ($orgName)",
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
      ),
    );
  }
}
