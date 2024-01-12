import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';

import 'package:about/about.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    Key? key,
    required this.title,
    this.onTap, required this.iconData,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
          trailing: Icon(
iconData,            color: Color(0xff212427),
          ),
          title: Text(
            title,
            style: TextStyle(),
          ),
          onTap: onTap),
    );
  }
}
                