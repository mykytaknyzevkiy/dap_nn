import 'package:dap_app_new/MusicController.dart';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreenBloc {
  final BehaviorSubject<List<TrackModel>> _filteredSongs$ = BehaviorSubject<List<TrackModel>>.seeded([]);

  BehaviorSubject<List<TrackModel>> get filteredSongs$ => _filteredSongs$;

  void updateFilteredSongs(String filter) async {
    _filteredSongs$.add(null);
    List<TrackModel> _filteredSongs = await searchSong(filter);
    _filteredSongs$.add(_filteredSongs);
  }

  void dispose() {
    _filteredSongs$.close();
  }
}
