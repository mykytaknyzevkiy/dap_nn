import 'package:dap_app_new/Screens/settings/play_back_list.dart';
import 'package:flutter/material.dart';
import '../MyLocalizations.dart';
import '../blocs/global.dart';
import '../sign_in.dart';
import 'SplashScreen.dart';
import 'get_waves/GetwavesScreen.dart';
import 'login/login_screen.dart';
import 'music_homepage/music_homepage.dart';
import 'search/search_screen.dart';
import 'settings/settings_screen.dart';

class DosPlayerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBlocN = GlobalBloc.instance();
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (myUserModel == null) {
          return SplashScreen();
        }
        return Scaffold(
            appBar: appBar(context),
            drawer: drawer(context),
            body: MusicHomepage(context)
        );
      },

    );
  }

}

Widget drawer(BuildContext context) {
  final localy = AppLocalizations.of(context);
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child:
              HeaderContainer(context, myUserModel!.imageUrl, myUserModel!.name),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        ListTile(
          title: Text(localy.translate("log_out")),
          leading: const Icon(Icons.person),
          onTap: () {
            logOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ));
          },
        ),
        ListTile(
          title: Text(localy.translate('get_new_tracks')),
          leading: const Icon(Icons.library_music),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return GetWavesScreen();
              },
            ));
          },
        ),
        ListTile(
          title: Text(localy.translate('playback')),
          leading: const Icon(Icons.alarm_add),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return PlaybackScreen();
              },
            ));
          },
        ),
        ListTile(
          title: Text(localy.translate("settings")),
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
        ),
        ListTile(
          title: Text(localy.translate("terms_conditions")),
          leading: const Icon(Icons.poll),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

AppBar appBar(BuildContext context) {
  final localy = AppLocalizations.of(context);

  return AppBar(
    title: Text(localy.translate("my_waves")),
    backgroundColor: Color(0xFF2F80ED),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 35,
          ),
        ),
      )
    ],
  );
}

HeaderContainer(BuildContext context, String imageUrl, String name) {
  return Scaffold(
    body: Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
              imageUrl,
            ),
            radius: 35,
            backgroundColor: Colors.transparent,
          ),
          Text(
            '',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}
