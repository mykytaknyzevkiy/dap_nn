import 'package:dap_app_new/MyLocalizations.dart';
import 'package:dap_app_new/Screens/all_songs/song_tile.dart';
import 'package:dap_app_new/blocs/global.dart';
import 'package:dap_app_new/common/empty_screen.dart';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GetWavesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetWavesScreenState();
}

class _GetWavesScreenState extends State<GetWavesScreen> {

  GlobalBloc _globalBloc = GlobalBloc.instance();

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context);
    final view = Scaffold(
      appBar: AppBar(
        title: Text(translate.translate('get_new_tracks')),
        backgroundColor: Color(0xFF2F80ED),
      ),
      body: Scaffold(
        body: StreamBuilder<MapEntry<List<TrackModel>, List<String>>>(
          stream: Rx.combineLatest2(
              _globalBloc.musicControllerBloc.fullTracks,
              _globalBloc.musicControllerBloc.userTrackIds,
                  (List<TrackModel> a, List<String> b) => MapEntry(a, b)
          ),
          builder:
              (BuildContext context, AsyncSnapshot<MapEntry<List<TrackModel>, List<String>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final _fullSongs = snapshot.data!.key;
            final _userTracksId = snapshot.data!.value;

            final List<TrackModel> _songs = [];

            for (var track in _fullSongs) {
              if (!_userTracksId.contains(track.id))
                _songs.add(track);
            }

            if (_songs.length == 0) {
              return EmptyScreen(
                text: translate
                    .translate("no_new_tracks"),
              );
            }
            return songsList(_songs, context);
          },
        ),
      )
    );
    return view;
  }

}

