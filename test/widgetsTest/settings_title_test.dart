import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tell_me/screens/settingScreen/widgets/SettingsTile.dart';

void main() {
  testWidgets('test if the settings title exist', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Container(
            child: SettingTile(
              title: 'here',
              iconData: Icons.abc,
              key: Key('123'),
            ),
          ),
      ),
    ),
    );

    expect(find.text('here') ,findsOneWidget);
  });

  
}





