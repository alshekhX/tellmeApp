import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RegitrationButton extends StatelessWidget {
  const RegitrationButton({
    Key? key,
    required this.title,
    required this.color,
    this.onPressed, required this.iconData,
  }) : super(key: key);
  final void Function()? onPressed;

  final String title;
  final Color color;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: Colors.white,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          elevation: 2,
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        onPressed: onPressed);
  }
}
