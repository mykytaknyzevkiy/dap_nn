import 'package:dap_app_new/ui/widget/BaseContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpProfileState();
}

class SignUpProfileState extends State<SignUpProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return baseContainer(
        context,
        new SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 80.0),
              child: new Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Icon(
                        Icons.headset_mic,
                        color: Color(0xFF2F80ED),
                        size: 50.0,
                      ),
                    ),
                  ),
                  new Text(
                    "NAME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F80ED),
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
