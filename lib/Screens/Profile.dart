import 'package:flutter/material.dart';
import '../Objects/user.dart';

class Profile extends StatelessWidget {
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Data from logged in user:"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Name: ${user.name}"),
                Text("Email: ${user.email}"),
                Text("Facebook ID: ${user.fbID}"),
                Text("Picture url: ${user.url}")
              ],
            )
            //child: _displayUserData(user.profileData),
          ),
      ),
    );
  }

}
