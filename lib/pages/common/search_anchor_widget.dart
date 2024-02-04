import 'package:flutter/material.dart';
import 'package:test/backend/local_functions/util.dart';

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
  } else
    throw Exception("######### wrong file type for search anchor!");

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
