import 'package:dap_app_new/MyLocalizations.dart';
import 'package:dap_app_new/Screens/all_songs/song_tile.dart';
import 'package:dap_app_new/blocs/global.dart';
import 'package:dap_app_new/common/empty_screen.dart';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

AllSongsScreen(BuildContext context) {
  final translate = AppLocalizations.of(context);
  final GlobalBloc _globalBloc = GlobalBloc.instance();

  return StreamBuilder<MapEntry<List<TrackModel>, List<String>>>(
    stream: Rx.combineLatest2(
        _globalBloc.musicControllerBloc.fullTracks,
        _globalBloc.musicControllerBloc.userTrackIds, (List<TrackModel> a, List<String> b) => MapEntry(a, b)
    ),
    builder: (BuildContext context,
        AsyncSnapshot<MapEntry<List<TrackModel>, List<String>>> snapshot) {

      if (!snapshot.hasData ||
          snapshot.data?.key == null ||
          snapshot.data?.value == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final _fullSongs = snapshot.data!.key;
      final _userTracksId = snapshot.data!.value;

      final List<TrackModel> songs = [];

      for (var track in _fullSongs) {
        if (_userTracksId.contains(track.id)) songs.add(track);
      }

      if (songs.isEmpty) {
        return EmptyScreen(
          text: translate.translate("you_do_not_have_any_songs_on_your_device"),
        );
      }

      return songsList(songs, context);
    },
  );
}
