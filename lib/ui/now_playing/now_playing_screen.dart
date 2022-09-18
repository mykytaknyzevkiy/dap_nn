import 'package:dap_app_new/ui/now_playing/preferences_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../blocs/global.dart';
import '../../common/music_icons.dart';
import '../../models/TrackModel.dart';
import '../../models/playerstate.dart';
import 'album_art_container.dart';
import 'empty_album_art.dart';
import 'music_board_controls.dart';

class NowPlayingScreen extends StatelessWidget {
  final PanelController _controller;

  NowPlayingScreen({required PanelController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = GlobalBloc.instance();

    final double _radius = 0.0;

    final double _screenHeight = MediaQuery.of(context).size.height;

    final double _albumArtSize = _screenHeight / 2.1;

    return StreamBuilder<MapEntry<PlayerState, TrackModel>>(
      stream: _globalBloc.musicControllerBloc.trackStates,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        TrackModel trackModel = snapshot.data!.value;
        PlayerState state = snapshot.data!.key;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: _albumArtSize + 50,
              child: Stack(
                children: <Widget>[
                  AlbumArtContainer(
                      _radius,
                      _albumArtSize,
                      trackModel
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MusicBoardControls(),
                  ),
                ],
              ),
            ),
            PreferencesBoard(),
            Divider(
              color: Colors.transparent,
              height: _screenHeight / 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 12,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            trackModel.category.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFADB9CD),
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(
                            height: 5,
                            color: Colors.transparent,
                          ),
                          Text(
                            trackModel.name,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Color(0xFF4D6B9C),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            trackModel.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => _controller.close(),
                      child: HideIcon(
                        color: const Color(0xFF90A4D4),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

}
