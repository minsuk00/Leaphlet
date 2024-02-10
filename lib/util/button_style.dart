import 'package:flutter/material.dart';

ButtonStyle getButtonStyle(String code, String selectedCode) {
  double getElevation() {
    return code == selectedCode ? 10.0 : 0.0;
  }

  Color? getBgColor() {
    return code == selectedCode
        ? const Color.fromARGB(255, 4, 114, 77)
        : const Color.fromARGB(240, 62, 136, 94);
  }

  EdgeInsets getPadding() {
    return EdgeInsets.all(
      code == selectedCode ? 8.0 : 0.0,
    );
  }

  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: getBgColor(),
    shadowColor: Colors.black,
    elevation: getElevation(),
    padding: getPadding(),
  );
}
