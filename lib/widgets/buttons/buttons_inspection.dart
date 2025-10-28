import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InspectionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const InspectionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const rightArrow = Icon(CupertinoIcons.chevron_right, color: Colors.white);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          Spacer(),
          rightArrow,
        ],
      ),
    );
  }
}
