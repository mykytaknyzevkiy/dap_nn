import 'package:flutter/material.dart';

Widget loadWidget() {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          height: 50,
          width: 50,
        )
      ],
    ),
  );
}