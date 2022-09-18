import 'package:flutter/material.dart';

Container baseContainer(BuildContext context, Widget child) {
  return new Container(
    height: MediaQuery.of(context).size.height,
    padding: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
    decoration: BoxDecoration(
      color: Colors.black87,
      image: DecorationImage(
        colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.05), BlendMode.dstATop),
        image: AssetImage('assets/images/BeFunky-design.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: child,
  );
}