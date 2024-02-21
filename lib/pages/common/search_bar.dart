import 'package:flutter/material.dart';
import 'package:leaphlet/backend/local_functions/util.dart';

// ignore: must_be_immutable
class CustomSearchBar extends StatefulWidget {
  double widthRatio;
  GlobalKey parentKey;
  Map<String, GlobalKey> keyDict;
  Function setSelectedCode;
  SearchController searchController;
  ScrollController scrollController;
  FileType fileType;
  List dataList;
  CustomSearchBar({
    Key? key,
    required this.widthRatio,
    required this.dataList,
    required this.parentKey,
    required this.keyDict,
    required this.setSelectedCode,
    required this.fileType,
    required this.scrollController,
    required this.searchController,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  void modifyItemCode(String code) {
    double anchorY = 0;
    double targetY = 0;

    if (code != "") {
      RenderBox box =
          widget.parentKey.currentContext?.findRenderObject() as RenderBox;
      anchorY = box.localToGlobal(Offset.zero).dy;

      BuildContext? ctx = widget.keyDict[code]?.currentContext;
      if (ctx == null) {
        //workaround. for some reason the bottom events has null for global key
        targetY = widget.parentKey.currentContext!.size!.height + anchorY;
      } else {
        RenderBox tBox = ctx.findRenderObject() as RenderBox;
        targetY = tBox.localToGlobal(Offset.zero).dy;
      }
    }

    widget.setSelectedCode(code);
    // setState(() {
    if (code != "") {
      widget.scrollController.animateTo(
        targetY - anchorY,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final SearchAnchor searchAnchor = getSearchAnchor(context, widget.dataList,
        widget.fileType, setState, modifyItemCode, widget.searchController);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: widget.widthRatio * screenWidth,
        child: searchAnchor,
      ),
    );
  }
}

SearchAnchor getSearchAnchor(
    BuildContext context,
    List targetData,
    FileType fileType,
    Function setState,
    Function modifyItemCode,
    SearchController searchController) {
  late String elementNameKey;
  late String elementCodeKey;
  if (fileType == FileType.event) {
    elementNameKey = 'eventName';
    elementCodeKey = 'eventCode';
  } else if (fileType == FileType.booth) {
    elementNameKey = 'orgName';
    elementCodeKey = 'boothCode';
  } else {
    throw Exception("######### wrong file type for search anchor!");
  }

  // final SearchController searchController = SearchController();
  // print("======================SEARCH ANCHOR REBUILD===================");

  return SearchAnchor(
    searchController: searchController,
    isFullScreen: false,
    // viewLeading: const Icon(null),
    viewLeading: IconButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back)),
    viewTrailing: [
      IconButton(
        onPressed: () {
          modifyItemCode("");
          searchController.clear();
          // can't update suggestions manually. flutter issue #132161
          // workaround.
          searchController.closeView("");
          searchController.openView();
        },
        icon: const Icon(Icons.close),
      )
    ],
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
        // onSubmitted: (value) => print("##############################submitted!!!!!!!!!!"),
        leading: const Icon(Icons.search),
        hintText: 'SEARCH',
      );
    },
    suggestionsBuilder: (BuildContext context, SearchController controller) {
      // print("############## ${controller.text}");
      List<dynamic> outputList = targetData
          .where((element) => element[elementNameKey]
              .toLowerCase()
              .contains(controller.text.toLowerCase()))
          .toList();
      return List<ListTile>.generate(outputList.length, (index) {
        final String name = outputList[index][elementNameKey];
        final String code = outputList[index][elementCodeKey];
        return ListTile(
            title: Text(name),
            onTap: () {
              modifyItemCode(
                code,
              );
              FocusScope.of(context).unfocus();
              setState(() {
                controller.closeView(name);
              });
            });
      });
    },
  );
}
