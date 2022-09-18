import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:volume/volume.dart';

import '../../MyLocalizations.dart';
import '../../blocs/global.dart';
import '../../main.dart';
import '../../sign_in.dart';
import '../../unit/MyConst.dart';
import 'info_app.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum Times { e, r, y }

class _SettingsScreenState extends State<SettingsScreen> {
  String _soundTime = '';
  late AudioManager audioManager;
  int? maxVol, currentVol;
  String? lastSelectedValue;

  @override
  void initState() {
    super.initState();
    audioManager = AudioManager.STREAM_MUSIC;
    initPlatformState();
    updateVolumes();
  }

  updateData() async {
    final prefs = await SharedPreferences.getInstance();
    final translate = AppLocalizations.of(context);
    setState(() {
      _soundTime = '${prefs.getDouble(MyConst.user_track_time_key)} ${translate.translate('sec')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context);
    final view = Scaffold(
      appBar: AppBar(
        title: Text(translate.translate('settings')),
        backgroundColor: Color(0xFF2F80ED),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(translate.translate('general')),
            tiles: [
              SettingsTile(
                title: Text(translate.translate('how_to_use')),
                leading: const Icon(Icons.info_outline),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => InfoScreen()));
                },
              ),
            ],
          ),
          /*SettingsSection(
            title: 'Common',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));
                },
              ),
              SettingsTile(
                title: 'Sign out',
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  if (Platform.isAndroid) {
                    _showLogOutDialog();
                  } else if (Platform.isIOS) {
                    _showLogOut();
                  }
                },
              ),
            ],
          ),*/
          SettingsSection(
            title: Text(translate.translate('sound')),
            tiles: [
              SettingsTile(
                title: Text(translate.translate('level_of_the_volume')),
                value: Text(currentVol != null ? currentVol.toString() : ''),
                leading: const Icon(Icons.volume_up),
                onPressed: (con) {
                  _showDialog();
                },
              ),
              /*SettingsTile(
                title: translate.translate('sound_time'),
                subtitle: _soundTime,
                leading: Icon(Icons.access_alarms),
                onTap: () {
                  if (Platform.isAndroid) {
                    _showSoundTimeDialog();
                  } else if (Platform.isIOS) {
                    _onActionSheetPress(context);
                  }
                },
              ),*/
            ],
          ),
          /*SettingsSection(
            title: translate.translate('playback'),
            tiles: [
              SettingsTile(
                title: translate.translate('add_playback_time'),
                leading: Icon(Icons.alarm_add),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PlaybackScreen()));
                },
              ),
            ],
          ),*/
        ],
      ),
    );
    return view;
  }

  /*------------------------------ Logout section start ----------------------------*/

  /*Logout dialog for iOS Platform*/
  void _showLogOut() {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Logout"),
          content: new Text("Are you sure you want to logout the app?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () {
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return MyApp();
                }), ModalRoute.withName('/'));
                //_globalBloc.dispose();
              },
            ),
            CupertinoDialogAction(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  /*Logout dialog for Android Platform*/
  void _showLogOutDialog() {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Text(
            "Are you sure you want to logout the app?",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              textColor: Color(0xFF2F80ED),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO"),
            ),
            MaterialButton(
              textColor: Color(0xFF2F80ED),
              onPressed: () {
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return MyApp();
                }), ModalRoute.withName('/'));
                //_globalBloc.dispose();
              },
              child: Text("YES"),
            ),
          ],
        );
      },
    );
  }

  /*------------------------------ Logout section end -------------------------------*/

  /*------------------------------ Sound time section start ----------------------------*/

  /*Sound time dialog for iOS Platform*/
  void _onActionSheetPress(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final translate = AppLocalizations.of(context);

    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate.translate('sound_time')),
        message: Text(translate.translate('please_select_play_duration')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('60' + translate.translate('sec')),
            onPressed: () {
              prefs.setDouble(MyConst.user_track_time_key, 60.0);
              setState(() {
                _soundTime = '60' + translate.translate('sec');
              });
              Navigator.of(context, rootNavigator: true).pop("60 sec");
            },
          ),
          CupertinoActionSheetAction(
            child: Text('90' + translate.translate('sec')),
            onPressed: () {
              prefs.setDouble(MyConst.user_track_time_key, 90.0);
              setState(() {
                _soundTime = '90' + translate.translate('sec');
              });
              Navigator.of(context, rootNavigator: true).pop("90 sec");
            },
          ),
          CupertinoActionSheetAction(
            child: Text('120' + translate.translate('sec')),
            onPressed: () {
              prefs.setDouble(MyConst.user_track_time_key, 120.0);
              setState(() {
                _soundTime = '120' + translate.translate('sec');
              });
              Navigator.of(context, rootNavigator: true).pop("120 sec");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate.translate('cancel')),
          isDefaultAction: true,
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop("Discard"),
        ),
      ),
    );
  }

  /*Sound time dialog for Android Platform*/
  void _showSoundTimeDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final translate = AppLocalizations.of(context);

    slideDialog.showSlideDialog(
      context: context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            translate.translate('sound_time'),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              translate.translate('please_select_play_duration'),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  SimpleDialogOption(
                      onPressed: () {
                        prefs.setDouble(MyConst.user_track_time_key, 60.0);
                        setState(() {
                          _soundTime = '60 ' + translate.translate('sec');
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                      child: Center(
                        child: new Text(
                          '60 ' + translate.translate('sec'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      )),
                  SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          prefs.setDouble(MyConst.user_track_time_key, 90.0);
                          _soundTime = '90 ' + translate.translate('sec');
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                      child: Center(
                        child: new Text(
                          '90 ' + translate.translate('sec'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      )),
                  SimpleDialogOption(
                      onPressed: () {
                        prefs.setDouble(MyConst.user_track_time_key, 120.0);
                        setState(() {
                          _soundTime = '120 ' + translate.translate('sec');
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                      child: Center(
                        child: new Text(
                          '120 ' + translate.translate('sec'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      )),
                ],
              )),
        ],
      ),
      barrierColor: Colors.black87.withOpacity(0.4),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }

  /*------------------------------ Sound time section end -------------------------------*/

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  updateVolumes() async {
    maxVol = await Volume.getMaxVol;
    currentVol = await Volume.getVol * 100 ~/ maxVol!;
  }

  setVol(int i) async {
    await Volume.setVol(i * maxVol! ~/ 100);
  }

  void _showDialog() {
    final translate = AppLocalizations.of(context);

    slideDialog.showSlideDialog(
      context: context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            translate.translate('add_playback_time'),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Container(
              padding: const EdgeInsets.all(40.0),
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(progressBarWidth: 10)),
                min: 0,
                max: 100,
                initialValue: currentVol!.toDouble(),
                onChange: (double value) {
                  setVol(value.toInt());
                  // callback providing a value while its being changed (with a pan gesture)
                },
                onChangeStart: (double startValue) {
                  // callback providing a starting value (when a pan gesture starts)
                },
                onChangeEnd: (double endValue) {
                  setState(() {
                    if (endValue > 0)
                      this.currentVol = endValue.toInt() + 1;
                    else
                      this.currentVol = 0;
                  });
                },
              )),
        ],
      ),
      barrierColor: Colors.black87.withOpacity(0.4),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }

  void showDemoActionSheet({required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }
}
