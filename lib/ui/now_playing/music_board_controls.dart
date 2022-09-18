import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:provider/provider.dart';

import '../../blocs/global.dart';
import '../../models/TrackModel.dart';
import '../../models/playerstate.dart';

class MusicBoardControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = GlobalBloc.instance();
    return Container(
      height: 100,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<MapEntry<PlayerState, TrackModel>>(
                stream: _globalBloc.musicControllerBloc.trackStates,
                builder: (BuildContext context,
                    AsyncSnapshot<MapEntry<PlayerState, TrackModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final PlayerState _state = snapshot.data!.key;
                  final TrackModel _currentSong = snapshot.data!.value;
                  return GestureDetector(
                    onTap: () {
                      if (PlayerState.paused == _state) {
                        _globalBloc.musicControllerBloc.playTrack(_currentSong);
                      }
                      else {
                        _globalBloc.musicControllerBloc.pauseTrack(_currentSong);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: Offset(2, 1.5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 200),
                          crossFadeState: _state == PlayerState.playing
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: const Icon(
                            Icons.pause,
                            size: 50,
                            color: Color(0xFF7B92CA),
                          ),
                          secondChild: const Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Color(0xFF7B92CA),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
