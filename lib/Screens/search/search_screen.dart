import 'package:dap_app_new/MyLocalizations.dart';
import 'package:dap_app_new/Screens/all_songs/song_tile.dart';
import 'package:dap_app_new/Screens/search/search_screen_bloc.dart';
import 'package:dap_app_new/models/TrackModel.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final SearchScreenBloc _searchScreenBloc = SearchScreenBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localy = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF274D85),
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            controller: _textEditingController,
            cursorColor: const Color(0xFF274D85),
            decoration: InputDecoration(
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFFD9EAF1).withOpacity(0.7),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFFD9EAF1).withOpacity(0.7),
                ),
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF274D85),
              fontSize: 22.0,
            ),
            autofocus: true,
            onChanged: (String value) {
              _searchScreenBloc.updateFilteredSongs(value);
            },
          ),
        ),
        body: StreamBuilder<List<TrackModel>>(
          stream: _searchScreenBloc.filteredSongs$,
          builder: (BuildContext contextN, AsyncSnapshot<List<TrackModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<TrackModel> filteredSongs = snapshot.data!;
            if (filteredSongs.isEmpty) {
              return Center(
                child: Text(
                  localy.translate("enter_proper_keywords_to_start_searching"),
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: Color(0xFF274D85),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return songsList(filteredSongs, context);
          },
        ),
      ),
    );
  }
}
