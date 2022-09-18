import 'package:dap_app_new/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'MyLocalizations.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/login/login_screen.dart';

import 'Screens/root.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Healthy Waves",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black87,
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.dstATop),
            image: const AssetImage('assets/images/BeFunky-design.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () => {
            FocusScope.of(context).requestFocus(FocusNode())
          },
          child: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SplashScreen();
              if (myUserModel != null) {
                return DosPlayerApp();
              } else {
                return LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
