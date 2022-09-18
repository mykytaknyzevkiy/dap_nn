import 'package:dap_app_new/MusicController.dart';

import 'music_player.dart';

GlobalBloc? _globalBloc;

class GlobalBloc {
  final MusicPlayerBloc _musicPlayerBloc = MusicPlayerBloc();
  MusicPlayerBloc get musicPlayerBloc => _musicPlayerBloc;
  MusicController musicControllerBloc = MusicController();

  static GlobalBloc instance() {
    if (_globalBloc != null) {
      return _globalBloc!;
    }
    else {
      return GlobalBloc();
    }
  }

  GlobalBloc() {
    _globalBloc = this;
  }

  void dispose() {
    _musicPlayerBloc.dispose();
    musicControllerBloc.dispose();
  }
}
