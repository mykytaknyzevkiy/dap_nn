import 'dart:convert';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:dap_app_new/models/playback.dart';
import 'package:dap_app_new/models/playerstate.dart';
import 'package:dap_app_new/models/song_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef void TimeChangeHandler(Duration duration);
typedef void ErrorHandler(String message);

class MusicPlayerBloc {
  final _songs$ = BehaviorSubject<List<TrackModel>>();
  final _isAudioSeeking$ = BehaviorSubject<bool>.seeded(false);
  final _position$ = BehaviorSubject<Duration>();
  final _playlist$ = BehaviorSubject<MapEntry<List<TrackModel>, List<TrackModel>>>();
  final _playback$ = BehaviorSubject<List<Playback>>.seeded([]);
  final _favorites$ = BehaviorSubject<List<TrackModel>>.seeded([]);
  final _playerState$ = BehaviorSubject<MapEntry<PlayerState, TrackModel?>>.seeded(
  const MapEntry(PlayerState.paused, null,),);
  final _usersTrackIds = BehaviorSubject<String>.seeded("");

  final MusicPlayerN _audioPlayer = MusicPlayerN();

  TimeChangeHandler? durationHandler;
  TimeChangeHandler? positionHandler;
  ErrorHandler? errorHandler;

  BehaviorSubject<List<TrackModel>> get songs$ => _songs$;
  BehaviorSubject<MapEntry<PlayerState, TrackModel?>> get playerState$ =>
      _playerState$;
  BehaviorSubject<Duration> get position$ => _position$;
  BehaviorSubject<List<Playback>> get playback$ => _playback$;
  BehaviorSubject<List<TrackModel>> get favorites$ => _favorites$;

  BehaviorSubject<String> get usersTrackIds => _usersTrackIds;

  MusicPlayerBloc() {
    _initStreams();
    _initObservers();
  }

  void setDurationHandler(TimeChangeHandler handler) {
    durationHandler = handler;
  }

  void setPositionHandler(TimeChangeHandler handler) {
    positionHandler = handler;
  }

  /*void setStartHandler(VoidCallback callback) {
    startHandler = callback;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }*/

  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }

  void userHasPayedTrack(TrackModel trackModel) {
    _usersTrackIds.add(trackModel.id);
  }

  void playMusic(TrackModel song) {
    _audioPlayer.play(song);
  }

  void pauseMusic(TrackModel song) {
    updatePlayerState(PlayerState.paused, song);
  }

  void stopMusic() {
  }

  void updatePlayerState(PlayerState state, TrackModel song) {
    _playerState$.add(MapEntry(state, song));
  }

  void updatePosition(Duration duration) {
    _position$.add(duration);
  }

  void updatePlaylist(List<TrackModel> normalPlaylist) {
    List<TrackModel> _shufflePlaylist = []..addAll(normalPlaylist);
    _shufflePlaylist.shuffle();
    _playlist$.add(MapEntry(normalPlaylist, _shufflePlaylist));
  }

  void _updateAlbums(List<TrackModel> songs) {
    //TODO(Nikita look)
    /*Map<int, Album> _albumsMap = {};
    for (TrackModel song in songs) {
      if (_albumsMap[song.albumId] == null) {
        _albumsMap[song.albumId] = Album.fromSong(song);
      }
    }
    final List<Album> _albums = _albumsMap.values.toList();
    _albums$.add(_albums);*/
  }

  void playNextSong() {
    final TrackModel? _currentSong = _playerState$.value.value;
    final bool _isShuffle = _playback$.value.contains(Playback.shuffle);
    final List<TrackModel> _playlist =
        _isShuffle ? _playlist$.value.value : _playlist$.value.key;
    int _index = _playlist.indexOf(_currentSong!);
    if (_index == _playlist.length - 1) {
      _index = 0;
    } else {
      _index++;
    }
    stopMusic();
    playMusic(_playlist[_index]);
  }

  void playPreviousSong() {

    final TrackModel? _currentSong = _playerState$.value.value;
    final bool _isShuffle = _playback$.value.contains(Playback.shuffle);
    final List<TrackModel> _playlist =
        _isShuffle ? _playlist$.value.value : _playlist$.value.key;
    int _index = _playlist.indexOf(_currentSong!);
    if (_index == 0) {
      _index = _playlist.length - 1;
    } else {
      _index--;
    }
    stopMusic();
    playMusic(_playlist[_index]);
  }

  void _playSameSong() {
    final TrackModel? _currentSong = _playerState$.value.value;
    stopMusic();
    playMusic(_currentSong!);
  }

  void _onSongComplete() {
    final List<Playback> _playback = _playback$.value;
    if (_playback.contains(Playback.repeatSong)) {
      _playSameSong();
      return;
    }
    playNextSong();
  }

  void audioSeek(double seconds) {

  }

  void addToFavorites(TrackModel song) async {
    List<TrackModel> _favorites = _favorites$.value;
    _favorites.add(song);
    _favorites$.add(_favorites);
    await saveFavorites();
  }

  void removeFromFavorites(TrackModel song) async {
    List<TrackModel> _favorites = _favorites$.value;
    _favorites.remove(song);
    _favorites$.add(_favorites);
    await saveFavorites();
  }

  void invertSeekingState() {
    final _value = _isAudioSeeking$.value;
    _isAudioSeeking$.add(!_value);
  }

  void updatePlayback(Playback playback) {
    List<Playback> _value = playback$.value;
    if (playback == Playback.shuffle) {
      final List<TrackModel> _normalPlaylist = _playlist$.value.key;
      updatePlaylist(_normalPlaylist);
    }
    _value.add(playback);
    _playback$.add(_value);
  }

  void removePlayback(Playback playback) {
    List<Playback> _value = playback$.value;
    _value.remove(playback);
    _playback$.add(_value);
  }

  Future<void> saveFavorites() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final List<TrackModel> _favorites = _favorites$.value;
    List<String> _encodedStrings = [];
    for (TrackModel song in _favorites) {
      _encodedStrings.add(_encodeSongToJson(song));
    }
    _prefs.setStringList("favorites", _encodedStrings);
  }

  void retrieveFavorites() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final List<TrackModel> _fetchedSongs = _songs$.value;
    List<String> _savedStrings = _prefs.getStringList("favorites") ?? [];
    List<TrackModel> _favorites = [];
    for (String data in _savedStrings) {
      final TrackModel song = _decodeSongFromJson(data);
      for (var fetchedSong in _fetchedSongs) {
        if (song.id == fetchedSong.id) {
          _favorites.add(fetchedSong);
        }
      }
    }
    _favorites$.add(_favorites);
  }

  String _encodeSongToJson(TrackModel song) {
    final _songMap = songToMap(song);
    final data = json.encode(_songMap);
    return data;
  }

  TrackModel _decodeSongFromJson(String ecodedSong) {
    final _songMap = json.decode(ecodedSong);
    final TrackModel _song = TrackModel.fromJson(_songMap);
    return _song;
  }

  Map<String, dynamic> songToMap(TrackModel song) {
    return song.toMap();
  }

  void _initObservers() {
    _songs$.listen(
      (List<TrackModel> songs) {
        _updateAlbums(songs);
      },
    ); // push albums from songs
  }

  void _initStreams() {
    _usersTrackIds.add("");
  }

  void dispose() {
    stopMusic();
    _isAudioSeeking$.close();
    _songs$.close();
    _playerState$.close();
    _playlist$.close();
    _position$.close();
    _playback$.close();
    _favorites$.close();
  }
}
