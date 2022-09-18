import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final IconData iconData;

  SocialIcon({required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(),
      child: Container(
        width: 40.0,
        height: 40.0,
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () {

          },
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}
