import 'package:beamer/beamer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('test logout', () {
    test('test adding shared prefrence', () async {
      SharedPreferences.setMockInitialValues({
        'flutter.userName':'ahmed'
      });
      SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove('userName');


    expect(pref.getString('userName'), null);
    });
  });
}
