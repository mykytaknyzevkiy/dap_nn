import 'package:audioplayers/audioplayers.dart';
import 'package:dap_app_new/models/TrackModel.dart';

import 'TrackModel.dart';

typedef void TimeChangeHandler(Duration duration);
typedef void ErrorHandler(String message);

class MusicPlayerN {
  //final _channel = MethodChannel('exit.live/music_player');

  final AudioPlayer audioPlayer = AudioPlayer();

  // === The different states ===
  void Function(TrackModel trackModel)? onIsPlaying;
  void Function(TrackModel trackModel)? onIsPaused;
  void Function(TrackModel trackModel)? onIsLoading;

  Function(int errorCode, [String errorMessage])? onError;


  play(TrackModel playlistItem) async {
    onIsLoading!(playlistItem);
    //await audioPlayer.stop();
    await audioPlayer.play(UrlSource(playlistItem.getUrl()));
    onIsPlaying!(playlistItem);
  }

  Future<int> playInt(TrackModel playlistItem) async {
    onIsLoading!(playlistItem);
    //await audioPlayer.stop();
    await audioPlayer.play(UrlSource(playlistItem.getUrl()));

    onIsPlaying!(playlistItem);

    return 1;
  }

  pause(TrackModel trackModel) async {
    audioPlayer.pause();
    onIsPaused!(trackModel);
  }

}
