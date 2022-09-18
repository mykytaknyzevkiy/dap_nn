import 'package:dap_app_new/MusicController.dart';
import 'package:dap_app_new/Screens/all_songs/song_tile.dart';
import 'package:dap_app_new/models/CategoryModel.dart';
import 'package:dap_app_new/sign_in.dart';
import 'package:dap_app_new/unit/Config.dart';
import 'package:dap_app_new/unit/MyConst.dart';

class TrackModel extends TrackAbs {
  final String id;
  final String name;
  final int price;
  final String description;
  final double duration;
  final albumArt = null;
  final album = "Bla bla album";
  final artist = "Artist bla bla";
  final albumId = 0;
  final CategoryModel category;

  //final String created;

  TrackModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.category,
      required this.duration});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> _map = {};
    _map['_id'] = id;
    _map['name'] = name;
    _map['price'] = price;
    _map['description'] = description;
    _map['category'] = category.toMap();
    _map['duration'] = duration;
    return _map;
  }

  String getUrl() {
    return '${Config.apiUrl}/tracks/$id/stream?token=${myUserModel!.token}';
  }

  double getRealDuration() {
    final key = "${MyConst.user_track_time_key}_$id";
    if (MusicController.prefs!.containsKey(key)) {
      return MusicController.prefs!.getDouble(key);
    } else {
      return duration;
    }
  }

  int getAlarmID() {
    return 4;
  }

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
        id: json['_id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        duration: json['duration'],
        category: CategoryModel.fromJson(json['category']));
  }
}
