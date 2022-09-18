import 'dart:collection';
import 'dart:ui';
import 'package:dap_app_new/MusicController.dart';
import 'package:dap_app_new/MyLocalizations.dart';
import 'package:dap_app_new/PayPalWebView.dart';
import 'package:dap_app_new/blocs/global.dart';
import 'package:dap_app_new/common/music_icons.dart';
import 'package:dap_app_new/models/CategoryModel.dart';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:dap_app_new/models/playerstate.dart';
import 'package:dap_app_new/ui/Commands.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class TrackAbs {}

class SongTileData {
  final MapEntry<PlayerState, TrackModel> trackPlay;
  final TrackModel payingTrack;

  SongTileData(this.trackPlay, this.payingTrack);
}

class SongTile extends StatelessWidget {
  final TrackModel song;

  GlobalBloc _globalBloc = GlobalBloc.instance();

  late AppLocalizations translate;

  SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {

    translate = AppLocalizations.of(context);

    return StreamBuilder<
            MapEntry<MapEntry<PlayerState, TrackModel>, TrackModel>>(
        stream: Rx.combineLatest2(
            _globalBloc.musicControllerBloc.trackStates,
            _globalBloc.musicControllerBloc.onPayingTrack,
            (MapEntry<PlayerState, TrackModel> a, TrackModel b) => MapEntry(a, b)),
        builder: (BuildContext context,
            AsyncSnapshot<
                    MapEntry<MapEntry<PlayerState, TrackModel>, TrackModel>>
                snapshot) {
          if (snapshot.hasData) {
            final PlayerState _state = snapshot.data!.key.key;

            final TrackModel _currentSong = snapshot.data!.key.value;

            return player(_state, _currentSong, snapshot.data!.value);
          } else {
            const PlayerState _state = PlayerState.paused;
            return player(_state, null, null);
          }
        });
  }

  Widget player(
      PlayerState _state, TrackModel? _currentSong, TrackModel? payingTrack) {
    final bool _isSelectedSong = song == _currentSong;
    return StreamBuilder<List<String>>(
      stream: _globalBloc.musicControllerBloc.userTrackIds,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) {
          return loadWidget();
        }
        return GestureDetector(
          onTap: () {
            if (snapshot.data!.contains(song.id)) {
              if (_isSelectedSong && _state == PlayerState.playing) {
                _globalBloc.musicControllerBloc.pauseTrack(song);
              } else {
                _globalBloc.musicControllerBloc.playTrack(song);
              }
            } else {
              startPayment(song, context);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        (!(snapshot.data!.contains(song.id)) ||
                                (payingTrack == song))
                            ? (payingTrack == song)
                                ? const CircularProgressIndicator()
                                : PayIcon(color: const Color(0xFFA1AFBC))
                            : ((_isSelectedSong &&
                                    _state == PlayerState.loading)
                                ? const CircularProgressIndicator()
                                : ((_isSelectedSong &&
                                        _state == PlayerState.playing)
                                    ? PauseIcon(color: const Color(0xFFA1AFBC))
                                    : PlayIcon(color: const Color(0xFFA1AFBC)))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                song.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF4D6B9C),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                width: 200,
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                      text: song.description,
                                      style: TextStyle(color: Colors.black),
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    (snapshot.data!.contains(song.id))
                        ? /*translate.translate('sound_time') + ': ' +*/ '${(song.getRealDuration()).toInt()} ${translate.translate('sec')}'
                        : '${song.price} €',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4D6B9C),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  startPayment(TrackModel trackModel, BuildContext context) async {
    _globalBloc.musicControllerBloc.onPayingTrack.add(trackModel);
    final paymentUrl = await trackPaymentUrl(song.id);
    if (paymentUrl != null) {
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PayPalWebView(paymentUrl, trackModel.id, _globalBloc);
            },
          )
      );
    }
    _globalBloc.musicControllerBloc.onPayingTrack.add(null);
  }
}

class SongTileSelect extends StatelessWidget {
  final TrackModel song;
  final Function(TrackModel) onSelect;

  GlobalBloc _globalBloc = GlobalBloc.instance();

  SongTileSelect({super.key, required this.song, required this.onSelect});


  @override
  Widget build(BuildContext context) {
    return player();
  }

  Widget player() {
    return GestureDetector(
      onTap: () {
        onSelect(song);
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    PlayIcon(color: Color(0xFFA1AFBC)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            song.name,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF4D6B9C),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryTile({super.key, required this.categoryModel});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            categoryModel.name,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4D6B9C),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                categoryModel.images[0].path_64,
              ),
              radius: 20,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}

Widget songsList(List<TrackModel> snapshot, BuildContext context) {
  final translate = AppLocalizations.of(context);
  final List<TrackModel> _songsN = snapshot;

  final tracksMap = LinkedHashMap<String, List<TrackModel>>();

  final categories = LinkedHashMap<String, CategoryModel>();

  for (var value in _songsN) {
    if (tracksMap.containsKey(value.category.id)) {
      tracksMap[value.category.id]!.add(value);
    }
    else {
      tracksMap[value.category.id] = [value];
    }
    categories[value.category.id] = value.category;
  }

  final trackes = <TrackAbs>[];

  for (var enty in tracksMap.entries) {
    trackes.add(categories[enty.key]!);
    trackes.addAll(enty.value);
  }

  return ListView.builder(
    key: PageStorageKey<String>(translate.translate("all_song")),
    padding: const EdgeInsets.only(bottom: 150.0),
    physics: const BouncingScrollPhysics(),
    itemCount: trackes.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      if (trackes[index] is TrackModel) {
        return SongTile(
          song: trackes[index] as TrackModel,
        );
      }
      return CategoryTile(categoryModel: trackes[index] as CategoryModel);
    },
  );
}

Widget usersSongsList(AsyncSnapshot<List<TrackModel>> snapshot,
    BuildContext context, Function(TrackModel) onSelect) {
  final _globalBlock = GlobalBloc.instance();

  final translate = AppLocalizations.of(context);
  final List<TrackModel> _songsN = snapshot.data!
      .where((track) => _globalBlock.musicControllerBloc.userTrackIds.value
          .contains(track.id))
      .toList();

  final tracksMap = LinkedHashMap<String, List<TrackModel>>();

  final categories = LinkedHashMap<String, CategoryModel>();

  for (var value in _songsN) {
    if (tracksMap.containsKey(value.category.id)) {
      tracksMap[value.category.id]!.add(value);
    } else {
      tracksMap[value.category.id] = [value];
    }
    categories[value.category.id] = value.category;
  }

  var trackes = <TrackAbs>[];

  for (var enty in tracksMap.entries) {
    trackes.add(categories[enty.key]!);
    trackes.addAll(enty.value);
  }

  return ListView.builder(
    key: PageStorageKey<String>(translate.translate("all_song")),
    padding: const EdgeInsets.only(bottom: 150.0),
    physics: BouncingScrollPhysics(),
    itemCount: trackes.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      if (trackes[index] is TrackModel) {
        return SongTileSelect(
          song: trackes[index] as TrackModel,
          onSelect: onSelect,
        );
      }
      return CategoryTile(categoryModel: trackes[index] as CategoryModel);
    },
  );
}
