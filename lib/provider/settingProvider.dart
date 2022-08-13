import 'package:flutter/cupertino.dart';

class Setting with ChangeNotifier {
  double fontSize = 1;
  String? fontSizeString;
  bool? nightmode;

  changeFontSize(double fontsize) {
    fontSize = fontsize;
    notifyListeners();
  }

  changeFontSizeString(String fontsizestring) {
    fontSizeString = fontsizestring;
    notifyListeners();
  }

  changeNightMode(bool nnightMode) {
    nightmode = nnightMode;
    notifyListeners();
  }







}
