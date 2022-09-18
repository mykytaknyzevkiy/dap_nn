import 'package:flutter/material.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../MyLocalizations.dart';
import '../../Screens/settings/play_back_list.dart';
import '../../blocs/global.dart';
import '../../models/TrackModel.dart';
import '../../unit/MyConst.dart';

class PreferencesBoard extends StatelessWidget {

  GlobalBloc _globalBloc = GlobalBloc.instance();
  late BuildContext context;

  late AppLocalizations translate;

  TrackModel? trackModel;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    trackModel = _globalBloc.musicControllerBloc.trackStates.value.value;

    translate = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            IconButton(
              onPressed: () {
                _showTimePicker(_globalBloc.musicControllerBloc.trackStates.value.value);
              },
              icon: const Icon(
                Icons.alarm_add,
                size: 35,
                color: Color(0xFFC7D2E3),
              ),
            ),
            Text(
              translate.translate('add_playback_time'),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4D6B9C),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            )
          ],
        ),
        Column(
          children: <Widget>[
            IconButton(
              onPressed: () {
                _showSoundTimeDialog();
              },
              icon: const Icon(
                Icons.access_time,
                size: 35,
                color: Color(0xFFC7D2E3),
              ),
            ),
            Text(
                '${translate.translate('sound_time')}: ${_globalBloc.musicControllerBloc.trackStates.value.value.getRealDuration().toInt()} ${translate.translate('sec')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4D6B9C),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis
            )
          ],
        )
      ],
    );
  }

  void _showTimePicker(TrackModel trackModel) {
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      _globalBloc.musicControllerBloc.addTackPlayBack(trackModel, args.value as DateTime);
    }
    AlertDialog(
        content: Scaffold(
          body: SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.single,
          ),
        )
    );
  }

  void _showSoundTimeDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final translate = AppLocalizations.of(context);

    final key = "${MyConst.user_track_time_key}_${trackModel!.id}";

    slideDialog.showSlideDialog(
      context: context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            translate.translate('sound_time'),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              translate.translate('please_select_play_duration'),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  SimpleDialogOption(
                      onPressed: () {
                        prefs.setDouble(key, 60.0);
                        _globalBloc.musicControllerBloc.trackStates.add(_globalBloc.musicControllerBloc.trackStates.value);
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                      child: Center(
                        child: Text(
                          '60 ${translate.translate('sec')}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      )),
                  SimpleDialogOption(
                      onPressed: () {
                        prefs.setDouble(key, 90.0);
                        _globalBloc.musicControllerBloc.trackStates.add(_globalBloc.musicControllerBloc.trackStates.value);
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                      child: Center(
                        child: Text(
                          '90 ${translate.translate('sec')}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      )),
                  SimpleDialogOption(
                      onPressed: () {
                        prefs.setDouble(key, 120.0);
                        _globalBloc.musicControllerBloc.trackStates.add(_globalBloc.musicControllerBloc.trackStates.value);
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                      child: Center(
                        child: Text(
                          '120 ${translate.translate('sec')}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
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

}
