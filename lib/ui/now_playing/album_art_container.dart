import 'package:flutter/material.dart';

import '../../models/TrackModel.dart';

AlbumArtContainer(
    double _radius,
    double _albumArtSize,
    TrackModel _currentSong) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: const [
          0.0,
          0.85,
        ],
        colors: [
          const Color(0xFF56CCF2).withOpacity(0.5),
          const Color(0xFF2F80ED).withOpacity(0.5),
        ],
      ),
    ),
    width: double.infinity,
    height: _albumArtSize,
    child: Image(
      image: NetworkImage(
        _currentSong.category.images[0].path_1000,
      ),
    ),
  );
}
