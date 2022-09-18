import 'package:dap_app_new/blocs/global.dart';
import 'package:dap_app_new/common/music_icons.dart';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:dap_app_new/models/playerstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget bottomPanel(
    BuildContext context,
    MapEntry<PlayerState, TrackModel> data) {

  final PlayerState _state = data.key;
  final TrackModel _currentSong = data.value;

  final GlobalBloc _globalBloc = GlobalBloc.instance();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            GestureDetector(
              child: _state == PlayerState.playing
                  ? PauseIcon(
                color: Colors.white,
              )
                  : PlayIcon(
                color: Colors.white,
              ),
              onTap: () {
                if (_state == PlayerState.playing) {
                  _globalBloc.musicControllerBloc.pauseTrack(_currentSong);
                }
                else {
                  _globalBloc.musicControllerBloc.playTrack(_currentSong);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                _currentSong.name,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        )
      ],
    ),
  );
}
